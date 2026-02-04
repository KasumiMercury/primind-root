output "instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = var.enabled ? google_sql_database_instance.postgres[0].name : null
}

output "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = var.enabled ? google_sql_database_instance.postgres[0].connection_name : null
}

output "private_ip" {
  description = "The private IP address of the Cloud SQL instance"
  value       = var.enabled ? google_sql_database_instance.postgres[0].private_ip_address : null
  sensitive   = true
}

output "enabled" {
  description = "Whether the database instance is enabled"
  value       = var.enabled
}
