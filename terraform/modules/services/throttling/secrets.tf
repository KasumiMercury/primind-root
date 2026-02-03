# Redis auth access
resource "google_secret_manager_secret_iam_member" "redis_auth_access" {
  project   = var.project_id
  secret_id = var.redis_auth_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.throttling.email}"
}
