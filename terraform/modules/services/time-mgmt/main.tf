locals {
  service_name = "primind-time-mgmt"
  labels = {
    app     = "primind"
    service = "time-mgmt"
    managed = "terraform"
  }
}

resource "google_cloud_run_v2_service" "time_mgmt" {
  project  = var.project_id
  name     = local.service_name
  location = var.region

  template {
    containers {
      image = "${var.artifact_registry_url}/kasumimercury/primind-remind-time-mgmt:${var.image_tag}"

      ports {
        container_port = 8080
      }

      resources {
        limits = {
          cpu    = var.cpu
          memory = var.memory
        }
        cpu_idle = true
      }

      env {
        name  = "ENV"
        value = "prod"
      }

      env {
        name  = "SERVICE_NAME"
        value = "time-mgmt"
      }

      env {
        name  = "GCLOUD_PROJECT_ID"
        value = var.project_id
      }

      env {
        name = "POSTGRES_DSN"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.postgres_dsn.secret_id
            version = "latest"
          }
        }
      }

      startup_probe {
        http_get {
          path = "/health/ready"
          port = 8080
        }
        initial_delay_seconds = 10
        timeout_seconds       = 5
        period_seconds        = 10
        failure_threshold     = 3
      }
    }

    vpc_access {
      connector = var.vpc_connector_id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    service_account = google_service_account.time_mgmt.email

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }
  }

  labels = local.labels

  depends_on = [
    google_secret_manager_secret_version.postgres_dsn,
    google_secret_manager_secret_iam_member.db_password_access,
    google_secret_manager_secret_iam_member.postgres_dsn_access,
  ]
}

# IAM binding for Cloud Tasks invocation is created in the central-backend module
# to avoid circular dependencies (central-backend depends on time-mgmt)
