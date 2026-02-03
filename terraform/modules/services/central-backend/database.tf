# Database on shared SQL instance
resource "google_sql_database" "central" {
  project  = var.project_id
  name     = var.database_name
  instance = var.sql_instance_name
}

# Database user
resource "google_sql_user" "central" {
  project  = var.project_id
  name     = var.database_user
  instance = var.sql_instance_name
  password = random_password.db_password.result
}
