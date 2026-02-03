# Service Account
resource "google_service_account" "throttling" {
  project      = var.project_id
  account_id   = "primind-throttling"
  display_name = "Primind Throttling Service Account"
}

# Common roles
resource "google_project_iam_member" "logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.throttling.email}"
}

resource "google_project_iam_member" "artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.throttling.email}"
}

# Cloud Monitoring (OpenTelemetry metrics)
resource "google_project_iam_member" "monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.throttling.email}"
}

# Cloud Trace (OpenTelemetry traces)
resource "google_project_iam_member" "cloudtrace" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.throttling.email}"
}

# Cloud Tasks enqueuer
resource "google_project_iam_member" "cloudtasks_enqueuer" {
  project = var.project_id
  role    = "roles/cloudtasks.enqueuer"
  member  = "serviceAccount:${google_service_account.throttling.email}"
}

# Cloud Tasks task deleter
resource "google_project_iam_member" "cloudtasks_deleter" {
  project = var.project_id
  role    = "roles/cloudtasks.taskDeleter"
  member  = "serviceAccount:${google_service_account.throttling.email}"
}

# Pub/Sub invoker service account (for push subscription)
resource "google_service_account" "pubsub_invoker" {
  project      = var.project_id
  account_id   = "primind-pubsub-invoker"
  display_name = "Primind Pub/Sub Invoker Service Account"
}

resource "google_project_iam_member" "pubsub_invoker_run" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.pubsub_invoker.email}"
}

# Scheduler service account
resource "google_service_account" "scheduler" {
  project      = var.project_id
  account_id   = "primind-throttle-scheduler"
  display_name = "Primind Throttle Scheduler Service Account"
}
