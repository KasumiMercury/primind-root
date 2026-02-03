# Service Account
resource "google_service_account" "notification_invoker" {
  project      = var.project_id
  account_id   = "primind-notification-invoker"
  display_name = "Primind Notification Invoker Service Account"
}

# Common roles
resource "google_project_iam_member" "logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.notification_invoker.email}"
}

resource "google_project_iam_member" "artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.notification_invoker.email}"
}

# Cloud Monitoring (OpenTelemetry metrics)
resource "google_project_iam_member" "monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.notification_invoker.email}"
}

# Cloud Trace (OpenTelemetry traces)
resource "google_project_iam_member" "cloudtrace" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.notification_invoker.email}"
}

# Firebase Cloud Messaging permission
resource "google_project_iam_member" "firebase" {
  project = var.project_id
  role    = "roles/firebase.sdkAdminServiceAgent"
  member  = "serviceAccount:${google_service_account.notification_invoker.email}"
}
