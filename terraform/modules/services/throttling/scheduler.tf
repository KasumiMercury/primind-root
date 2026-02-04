# Cloud Scheduler job for periodic throttle invocation
resource "google_cloud_scheduler_job" "throttle" {
  project     = var.project_id
  name        = "primind-throttle-scheduler"
  description = "Triggers throttling service periodically"
  region      = var.region
  schedule    = var.scheduler_schedule
  time_zone   = "Asia/Tokyo"
  paused      = var.scheduler_paused

  http_target {
    uri         = "${google_cloud_run_v2_service.throttling.uri}/api/v1/throttle"
    http_method = "POST"

    oidc_token {
      service_account_email = google_service_account.scheduler.email
    }
  }

  retry_config {
    retry_count          = 3
    min_backoff_duration = "5s"
    max_backoff_duration = "60s"
  }
}
