# Service Account
resource "google_service_account" "central_backend" {
  project      = var.project_id
  account_id   = "primind-central-backend"
  display_name = "Primind Central Backend Service Account"
}

# Common roles
resource "google_project_iam_member" "logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.central_backend.email}"
}

resource "google_project_iam_member" "artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.central_backend.email}"
}

# Cloud Monitoring (OpenTelemetry metrics)
resource "google_project_iam_member" "monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.central_backend.email}"
}

# Cloud Trace (OpenTelemetry traces)
resource "google_project_iam_member" "cloudtrace" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.central_backend.email}"
}

# Cloud SQL client
resource "google_project_iam_member" "cloudsql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.central_backend.email}"
}

# Cloud Tasks enqueuer
resource "google_project_iam_member" "cloudtasks" {
  project = var.project_id
  role    = "roles/cloudtasks.enqueuer"
  member  = "serviceAccount:${google_service_account.central_backend.email}"
}
