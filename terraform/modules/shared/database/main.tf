# Cloud SQL PostgreSQL Instance (shared)
# Databases and users are created by individual service modules
resource "google_sql_database_instance" "postgres" {
  count = var.enabled ? 1 : 0

  project          = var.project_id
  name             = var.instance_name
  region           = var.region
  database_version = var.database_version

  # Ensure private VPC connection is established first
  depends_on = [var.private_vpc_connection]

  settings {
    tier              = var.tier
    disk_size         = var.disk_size
    disk_type         = var.disk_type
    disk_autoresize   = false
    availability_type = "ZONAL" # Single zone for cost optimization
    activation_policy = var.stopped ? "NEVER" : "ALWAYS"

    ip_configuration {
      ipv4_enabled    = false # Private IP only
      private_network = var.private_network
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = false # Disabled for cost optimization
      transaction_log_retention_days = 1
      backup_retention_settings {
        retained_backups = 7
      }
    }

    maintenance_window {
      day          = 7 # Sunday
      hour         = 3
      update_track = "stable"
    }

    database_flags {
      name  = "max_connections"
      value = "50" # Limited for shared CPU
    }

    database_flags {
      name  = "log_temp_files"
      value = "0" # Log all temp files
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    insights_config {
      query_insights_enabled = false # Disabled for cost optimization
    }
  }

  deletion_protection = false # Always allow destroy
}
