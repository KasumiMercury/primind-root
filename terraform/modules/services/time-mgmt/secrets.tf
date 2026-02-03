# Auto-generate database password
resource "random_password" "db_password" {
  length  = 32
  special = false # Cloud SQL doesn't like some special chars
}

resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = "primind-timemgmt-db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

resource "google_secret_manager_secret_iam_member" "db_password_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.time_mgmt.email}"
}

# Store full Postgres DSN as secret
resource "google_secret_manager_secret" "postgres_dsn" {
  project   = var.project_id
  secret_id = "primind-timemgmt-postgres-dsn"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "postgres_dsn" {
  secret      = google_secret_manager_secret.postgres_dsn.id
  secret_data = "postgresql://${var.database_user}:${random_password.db_password.result}@${var.database_private_ip}:5432/${var.database_name}?sslmode=disable"
}

resource "google_secret_manager_secret_iam_member" "postgres_dsn_access" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.postgres_dsn.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.time_mgmt.email}"
}
