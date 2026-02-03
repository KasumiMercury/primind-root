# Service Account
resource "google_service_account" "time_mgmt" {
  project      = var.project_id
  account_id   = "primind-time-mgmt"
  display_name = "Primind Time Management Service Account"
}

# Common roles
resource "google_project_iam_member" "logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.time_mgmt.email}"
}

resource "google_project_iam_member" "artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.time_mgmt.email}"
}

# Cloud Monitoring (OpenTelemetry metrics)
resource "google_project_iam_member" "monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.time_mgmt.email}"
}

# Cloud Trace (OpenTelemetry traces)
resource "google_project_iam_member" "cloudtrace" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.time_mgmt.email}"
}

# Cloud SQL client
resource "google_project_iam_member" "cloudsql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.time_mgmt.email}"
}

# Pub/Sub publisher
resource "google_project_iam_member" "pubsub" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.time_mgmt.email}"
}
