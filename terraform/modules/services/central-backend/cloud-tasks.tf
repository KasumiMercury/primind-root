# Random suffix for queue names (generated once, stored in state)
resource "random_string" "queue_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Cloud Tasks queues for remind operations
resource "google_cloud_tasks_queue" "remind_register" {
  project  = var.project_id
  name     = "remind-register-${random_string.queue_suffix.result}"
  location = var.region

  rate_limits {
    max_dispatches_per_second = 500
    max_concurrent_dispatches = 100
  }

  retry_config {
    max_attempts  = 3
    min_backoff   = "1s"
    max_backoff   = "60s"
    max_doublings = 4
  }

  stackdriver_logging_config {
    sampling_ratio = 1.0
  }
}

resource "google_cloud_tasks_queue" "remind_cancel" {
  project  = var.project_id
  name     = "remind-cancel-${random_string.queue_suffix.result}"
  location = var.region

  rate_limits {
    max_dispatches_per_second = 500
    max_concurrent_dispatches = 100
  }

  retry_config {
    max_attempts  = 3
    min_backoff   = "1s"
    max_backoff   = "60s"
    max_doublings = 4
  }

  stackdriver_logging_config {
    sampling_ratio = 1.0
  }
}
