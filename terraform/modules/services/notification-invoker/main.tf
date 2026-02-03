locals {
  service_name = "primind-notification-invoker"
  labels = {
    app     = "primind"
    service = "notification-invoker"
    managed = "terraform"
  }
}

resource "google_cloud_run_v2_service" "notification_invoker" {
  project  = var.project_id
  name     = local.service_name
  location = var.region

  template {
    containers {
      image = "${var.artifact_registry_url}/kasumimercury/primind-notification-invoker:${var.image_tag}"

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
        value = "notification-invoker"
      }

      env {
        name  = "FIREBASE_PROJECT_ID"
        value = var.project_id
      }

      env {
        name  = "WEB_APP_BASE_URL"
        value = var.web_app_url
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

    service_account = google_service_account.notification_invoker.email

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }
  }

  labels = local.labels
}

# IAM binding for Cloud Tasks invocation is created in the throttling module
# to avoid circular dependencies (throttling depends on notification-invoker)
