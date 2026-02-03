locals {
  service_name = "primind-throttling"
  labels = {
    app     = "primind"
    service = "throttling"
    managed = "terraform"
  }
}

resource "google_cloud_run_v2_service" "throttling" {
  project  = var.project_id
  name     = local.service_name
  location = var.region

  template {
    containers {
      image = "${var.artifact_registry_url}/kasumimercury/primind-notification-throttling:${var.image_tag}"

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
        value = "notification-throttling"
      }

      env {
        name  = "GCLOUD_PROJECT_ID"
        value = var.project_id
      }

      env {
        name  = "GCLOUD_LOCATION_ID"
        value = var.region
      }

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

      # Cloud Tasks for notification invoke
      env {
        name  = "GCLOUD_QUEUE_ID"
        value = google_cloud_tasks_queue.invoke.name
      }

      env {
        name  = "GCLOUD_TARGET_URL"
        value = "${var.notification_invoker_url}/notify"
      }

      # Time-mgmt service URL
      env {
        name  = "REMIND_TIME_MANAGEMENT_URL"
        value = var.time_mgmt_url
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

    service_account = google_service_account.throttling.email

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }
  }

  labels = local.labels
}

# Allow Pub/Sub to invoke this service
resource "google_cloud_run_v2_service_iam_member" "pubsub_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.throttling.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.pubsub_invoker.email}"
}

# Allow Scheduler to invoke this service
resource "google_cloud_run_v2_service_iam_member" "scheduler_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.throttling.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.scheduler.email}"
}

# Grant throttling SA permission to invoke notification-invoker (for Cloud Tasks OIDC)
resource "google_cloud_run_v2_service_iam_member" "notification_invoker_invoker" {
  project  = var.project_id
  location = var.region
  name     = var.notification_invoker_service_name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.throttling.email}"
}

# Grant throttling SA permission to invoke time-mgmt (for direct HTTP calls with ID token)
resource "google_cloud_run_v2_service_iam_member" "time_mgmt_invoker" {
  project  = var.project_id
  location = var.region
  name     = var.time_mgmt_service_name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.throttling.email}"
}
