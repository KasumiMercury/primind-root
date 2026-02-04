# Primind Terraform Infrastructure

This directory contains Terraform configurations for deploying Primind to Google Cloud Platform.

## Setup

### 1. Create Terraform State Bucket

```bash
task tf:init-backend PROJECT_ID=your-project-id
```

### 2. Configure Variables

Copy the example file:
```bash
cp terraform/environments/prod/terraform.tfvars.example terraform/environments/prod/terraform.tfvars
```

Edit `environments/prod/terraform.tfvars`:
```hcl
project_id     = "your-project-id"
project_number = "123456789012"
region         = "asia-northeast2"
```

Set OIDC credentials:
```bash
export TF_VAR_oidc_google_client_id="your-google-client-id"
export TF_VAR_oidc_google_client_secret="your-google-client-secret"
```

Set Upstash credentials:
```bash
export TF_VAR_upstash_email="your-upstash-email"
export TF_VAR_upstash_api_key="your-upstash-api-key"
```

### 3. Initialize Terraform

```bash
task tf:init PROJECT_ID=your-project-id
```

### 4. Plan and Apply

```bash
task tf:plan
task tf:apply
```

### 5. Get Outputs

```bash
task tf:output
```

## Directory Structure

```
terraform/
├── modules/
│   ├── shared/
│   │   ├── networking/           # VPC, subnets, VPC connector, PSC
│   │   ├── database/             # Cloud SQL instance (no DBs/users)
│   │   ├── redis/                # Upstash Redis + auth secret
│   │   ├── bastion/              # Bastion VM for migrations (IAP SSH tunnel)
│   │   └── artifact-registry/    # GHCR proxy
│   │
│   └── services/
│       ├── central-backend/      # Cloud Run + DB + Redis + Cloud Tasks
│       │   ├── main.tf           # Cloud Run service
│       │   ├── iam.tf            # Service account + roles
│       │   ├── database.tf       # Database + User on shared SQL
│       │   ├── secrets.tf        # DB password, session, OIDC secrets
│       │   ├── cloud-tasks.tf    # remind-register, remind-cancel queues
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       ├── time-mgmt/            # Cloud Run + DB + Pub/Sub topic
│       │   ├── main.tf
│       │   ├── iam.tf
│       │   ├── database.tf
│       │   ├── secrets.tf
│       │   ├── pubsub.tf         # remind-events topic
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       ├── throttling/           # Cloud Run + Redis + Pub/Sub subscription
│       │   ├── main.tf
│       │   ├── iam.tf
│       │   ├── secrets.tf
│       │   ├── cloud-tasks.tf    # invoke queue
│       │   ├── pubsub.tf         # Subscription to remind-events
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       └── notification-invoker/ # Cloud Run + Firebase
│           ├── main.tf
│           ├── iam.tf            # Firebase permissions
│           ├── variables.tf
│           └── outputs.tf
│
├── environments/
│   └── prod/
│       ├── main.tf               # Module composition
│       ├── variables.tf          # Environment variables
│       ├── outputs.tf            # Environment outputs
│       ├── versions.tf           # Provider versions
│       ├── backend.tf            # GCS backend
│       └── terraform.tfvars.example
│
└── README.md
```

## Module Organization

### Shared Modules

Shared infrastructure used by multiple services:

| Module | Purpose |
|--------|---------|
| networking | VPC, subnets, VPC connector, Private Service Connection |
| database | Cloud SQL PostgreSQL instance (DBs created by service modules) |
| redis | Upstash Redis (serverless) + auth secret in Secret Manager |
| bastion | Bastion VM for database migrations (IAP SSH tunnel, on-demand) |
| artifact-registry | Remote repository proxying GHCR |

### Service Modules

Each service owns all its resources:

| Service | Resources |
|---------|-----------|
| central-backend | Cloud Run, Database+User, Secrets (DB, session, OIDC), Cloud Tasks (remind-register, remind-cancel) |
| time-mgmt | Cloud Run, Database+User, Secrets (DB), Pub/Sub Topic (remind-events) |
| throttling | Cloud Run, Secrets (Redis), Cloud Tasks (invoke), Pub/Sub Subscription |
| notification-invoker | Cloud Run, Firebase IAM |

## Service Dependencies

```
Shared Infrastructure (parallel)
├── networking
├── database
├── redis
└── artifact-registry
         │
         ▼
notification-invoker (no service deps)
         │
         ▼
time-mgmt (database only)
         │
         ▼
throttling (needs notification-invoker URL, time-mgmt URL/topic)
         │
         ▼
central-backend (needs time-mgmt URL)
```

## Service Accounts

| Service | Account | Special Permissions |
|---------|---------|---------------------|
| central-backend | primind-central-backend | cloudsql.client, cloudtasks.enqueuer, secretmanager.secretAccessor |
| time-mgmt | primind-time-mgmt | cloudsql.client, pubsub.publisher, secretmanager.secretAccessor |
| throttling | primind-throttling | cloudtasks.enqueuer, secretmanager.secretAccessor |
| notification-invoker | primind-notification-invoker | firebase.sdkAdminServiceAgent |

## Per-Service Configuration

Each service can be configured independently:

```hcl
services = {
  central_backend = {
    image_tag     = "v1.0.0"
    min_instances = 0
    max_instances = 3
    cpu           = "1"
    memory        = "512Mi"
    database = {
      name     = "primind_db"
      user     = "primind_user"
      password = "secure-password"
    }
  }
  time_mgmt = {
    image_tag     = "v1.0.0"
    # ... similar configuration
  }
  # ...
}
```

## Updating Images

To deploy a new image version:

1. Update the `image_tag` for the service in `environments/prod/terraform.tfvars`
2. Run `task tf:plan` to verify changes
3. Run `task tf:apply` to deploy

## Database Migrations

### Migration Workflow

**Step 1: Deploy bastion VM**

```bash
task gcp:bastion:up
```

This deploys a temporary e2-micro spot instance.

**Step 2: Start SSH tunnel (in a separate terminal)**

```bash
task gcp:tunnel
```

Keep this terminal open while running migrations.

**Step 3: Run migrations**

For **Bash/Zsh**:
```bash
# central-backend
DSN=$(task gcp:migrate:dsn:central)
task gcp:migrate:central POSTGRES_DSN="$DSN"

# time-mgmt
DSN=$(task gcp:migrate:dsn:time-mgmt)
task gcp:migrate:time-mgmt POSTGRES_DSN="$DSN"
```

For **Fish**:
```fish
# central-backend
set DSN (task gcp:migrate:dsn:central)
task gcp:migrate:central POSTGRES_DSN="$DSN"

# time-mgmt
set DSN (task gcp:migrate:dsn:time-mgmt)
task gcp:migrate:time-mgmt POSTGRES_DSN="$DSN"
```

**Step 4: Destroy bastion VM**

```bash
# Close the tunnel
task gcp:bastion:down
```

### Migration Commands Reference

| Command | Description |
|---------|-------------|
| `task gcp:bastion:up` | Deploy bastion VM |
| `task gcp:bastion:down` | Destroy bastion VM |
| `task gcp:tunnel` | Start SSH tunnel to Cloud SQL |
| `task gcp:migrate:dsn:central` | Print DSN for central-backend |
| `task gcp:migrate:dsn:time-mgmt` | Print DSN for time-mgmt |
| `task gcp:migrate:central` | Run central-backend migrations |
| `task gcp:migrate:time-mgmt` | Run time-mgmt migrations |
| `task gcp:migrate:status:central` | Check central-backend migration status |
| `task gcp:migrate:status:time-mgmt` | Check time-mgmt migration status |
| `task gcp:migrate:help` | Show migration workflow guide |

## Hibernation Mode (Cost Saving)

```bash
# Check current status
task gcp:status

# Enter hibernation (stop Cloud SQL, pause Scheduler)
task gcp:hibernate

# Wake up from hibernation
task gcp:wake
```
