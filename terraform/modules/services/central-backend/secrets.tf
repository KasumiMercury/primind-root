# Auto-generate database password
resource "random_password" "db_password" {
  length  = 32
  special = false # Cloud SQL doesn't like some special chars
}

resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = "primind-central-db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

resource "google_secret_manager_secret_iam_member" "db_password_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.central_backend.email}"
}

# Store full Postgres DSN as secret
resource "google_secret_manager_secret" "postgres_dsn" {
  project   = var.project_id
  secret_id = "primind-central-postgres-dsn"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "postgres_dsn" {
  secret      = google_secret_manager_secret.postgres_dsn.id
  secret_data = "postgresql://${var.database_user}:${random_password.db_password.result}@${var.database_private_ip}:5432/${var.database_name}?sslmode=disable"
}

resource "google_secret_manager_secret_iam_member" "postgres_dsn_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.postgres_dsn.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.central_backend.email}"
}

# Auto-generate session secret
resource "random_password" "session_secret" {
  length  = 64
  special = true
}

resource "google_secret_manager_secret" "session_secret" {
  project   = var.project_id
  secret_id = "primind-session-secret"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "session_secret" {
  secret      = google_secret_manager_secret.session_secret.id
  secret_data = random_password.session_secret.result
}

resource "google_secret_manager_secret_iam_member" "session_secret_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.session_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.central_backend.email}"
}

# OIDC client ID
resource "google_secret_manager_secret" "oidc_client_id" {
  project   = var.project_id
  secret_id = "primind-oidc-google-client-id"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "oidc_client_id" {
  secret      = google_secret_manager_secret.oidc_client_id.id
  secret_data = var.oidc_google_client_id
}

resource "google_secret_manager_secret_iam_member" "oidc_client_id_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.oidc_client_id.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.central_backend.email}"
}

# OIDC client secret
resource "google_secret_manager_secret" "oidc_client_secret" {
  project   = var.project_id
  secret_id = "primind-oidc-google-client-secret"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "oidc_client_secret" {
  secret      = google_secret_manager_secret.oidc_client_secret.id
  secret_data = var.oidc_google_client_secret
}

resource "google_secret_manager_secret_iam_member" "oidc_client_secret_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.oidc_client_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.central_backend.email}"
}

# Redis auth access
resource "google_secret_manager_secret_iam_member" "redis_auth_access" {
  project   = var.project_id
  secret_id = var.redis_auth_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.central_backend.email}"
}
