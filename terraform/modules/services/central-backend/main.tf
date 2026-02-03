locals {
  service_name = "primind-central-backend"
  labels = {
    app     = "primind"
    service = "central-backend"
    managed = "terraform"
  }
}

resource "google_cloud_run_v2_service" "central_backend" {
  project  = var.project_id
  name     = local.service_name
  location = var.region

  template {
    containers {
      image = "${var.artifact_registry_url}/kasumimercury/primind-central-backend:${var.image_tag}"

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
        value = "central-backend"
      }

      env {
        name  = "GCLOUD_PROJECT_ID"
        value = var.project_id
      }

      env {
        name  = "GCLOUD_LOCATION_ID"
        value = var.region
      }

      # Database
      env {
        name = "POSTGRES_DSN"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.postgres_dsn.secret_id
            version = "latest"
          }
        }
      }

      # Redis
      env {
        name  = "REDIS_ADDR"
        value = "${var.redis_host}:${var.redis_port}"
      }

      env {
        name = "REDIS_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = var.redis_auth_secret_id
            version = "latest"
          }
        }
      }

      env {
        name  = "REDIS_TLS"
        value = var.redis_tls_enabled ? "true" : "false"
      }

      # Cloud Tasks
      env {
        name  = "GCLOUD_REMIND_REGISTER_QUEUE_ID"
        value = google_cloud_tasks_queue.remind_register.name
      }

      env {
        name  = "GCLOUD_REMIND_CANCEL_QUEUE_ID"
        value = google_cloud_tasks_queue.remind_cancel.name
      }

      env {
        name  = "GCLOUD_REMIND_TARGET_URL"
        value = var.time_mgmt_url
      }

      # Session
      env {
        name = "SESSION_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.session_secret.secret_id
            version = "latest"
          }
        }
      }

      # OIDC
      env {
        name = "OIDC_GOOGLE_CLIENT_ID"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.oidc_client_id.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "OIDC_GOOGLE_CLIENT_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.oidc_client_secret.secret_id
            version = "latest"
          }
        }
      }

      env {
        name  = "OIDC_GOOGLE_REDIRECT_URI"
        value = var.oidc_google_redirect_uri
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

    service_account = google_service_account.central_backend.email

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }
  }

  labels = local.labels

  depends_on = [
    google_secret_manager_secret_version.postgres_dsn
  ]
}

# Public access for API
resource "google_cloud_run_v2_service_iam_member" "public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.central_backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Grant central-backend SA permission to invoke time-mgmt (for Cloud Tasks OIDC)
resource "google_cloud_run_v2_service_iam_member" "time_mgmt_invoker" {
  project  = var.project_id
  location = var.region
  name     = var.time_mgmt_service_name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.central_backend.email}"
}
