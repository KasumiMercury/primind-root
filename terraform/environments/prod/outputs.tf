# =============================================================================
# Shared Infrastructure Outputs
# =============================================================================

output "vpc_name" {
  description = "VPC network name"
  value       = module.networking.vpc_name
}

output "vpc_connector_id" {
  description = "VPC Access connector ID"
  value       = module.networking.vpc_connector_id
}

output "database_instance_name" {
  description = "Cloud SQL instance name"
  value       = module.database.instance_name
}

output "database_connection_name" {
  description = "Cloud SQL connection name"
  value       = module.database.instance_connection_name
}

output "database_private_ip" {
  description = "Cloud SQL private IP"
  value       = module.database.private_ip
  sensitive   = true
}

output "redis_host" {
  description = "Redis host"
  value       = module.redis.host
  sensitive   = true
}

output "redis_port" {
  description = "Redis port"
  value       = module.redis.port
}

output "artifact_registry_url" {
  description = "Artifact Registry URL"
  value       = module.artifact_registry.repository_url
}

# =============================================================================
# Service URLs
# =============================================================================

output "central_backend_url" {
  description = "Central backend service URL"
  value       = var.delete_costly_resources ? null : module.central_backend[0].service_url
}

output "time_mgmt_url" {
  description = "Time management service URL"
  value       = var.delete_costly_resources ? null : module.time_mgmt[0].service_url
}

output "throttling_url" {
  description = "Throttling service URL"
  value       = var.delete_costly_resources ? null : module.throttling[0].service_url
}

output "notification_invoker_url" {
  description = "Notification invoker service URL"
  value       = module.notification_invoker.service_url
}

# =============================================================================
# Service Names (for deployment scripts)
# =============================================================================

output "central_backend_name" {
  description = "Central backend service name"
  value       = var.delete_costly_resources ? null : module.central_backend[0].service_name
}

output "time_mgmt_name" {
  description = "Time management service name"
  value       = var.delete_costly_resources ? null : module.time_mgmt[0].service_name
}

output "throttling_name" {
  description = "Throttling service name"
  value       = var.delete_costly_resources ? null : module.throttling[0].service_name
}

output "notification_invoker_name" {
  description = "Notification invoker service name"
  value       = module.notification_invoker.service_name
}

# =============================================================================
# Service Accounts (for debugging/verification)
# =============================================================================

output "central_backend_service_account" {
  description = "Central backend service account email"
  value       = var.delete_costly_resources ? null : module.central_backend[0].service_account_email
}

output "time_mgmt_service_account" {
  description = "Time management service account email"
  value       = var.delete_costly_resources ? null : module.time_mgmt[0].service_account_email
}

output "throttling_service_account" {
  description = "Throttling service account email"
  value       = var.delete_costly_resources ? null : module.throttling[0].service_account_email
}

output "notification_invoker_service_account" {
  description = "Notification invoker service account email"
  value       = module.notification_invoker.service_account_email
}

# =============================================================================
# Messaging Infrastructure
# =============================================================================

output "remind_events_topic" {
  description = "Remind events Pub/Sub topic name"
  value       = var.delete_costly_resources ? null : module.time_mgmt[0].pubsub_topic_name
}

output "remind_register_queue" {
  description = "Remind register Cloud Tasks queue name"
  value       = var.delete_costly_resources ? null : module.central_backend[0].remind_register_queue_name
}

output "remind_cancel_queue" {
  description = "Remind cancel Cloud Tasks queue name"
  value       = var.delete_costly_resources ? null : module.central_backend[0].remind_cancel_queue_name
}

output "invoke_queue" {
  description = "Invoke Cloud Tasks queue name"
  value       = var.delete_costly_resources ? null : module.throttling[0].invoke_queue_name
}

# =============================================================================
# Migration Support Outputs (Bastion VM + SSH Tunnel)
# =============================================================================

output "bastion_enabled" {
  description = "Whether bastion VM is enabled"
  value       = module.bastion.enabled
}

output "bastion_tunnel_command" {
  description = "Command to create SSH tunnel for database access"
  value       = module.bastion.tunnel_command
  sensitive   = true
}

output "bastion_instance_name" {
  description = "Bastion instance name"
  value       = module.bastion.instance_name
}

output "bastion_zone" {
  description = "Bastion zone"
  value       = module.bastion.zone
}

# Database info for local atlas execution
output "central_backend_db_user" {
  description = "Central backend database user"
  value       = module.database.enabled ? var.services.central_backend.database.user : null
}

output "central_backend_db_name" {
  description = "Central backend database name"
  value       = module.database.enabled ? var.services.central_backend.database.name : null
}

output "central_backend_db_password_secret" {
  description = "Secret name for central backend database password"
  value       = module.database.enabled ? "primind-central-db-password" : null
}

output "time_mgmt_db_user" {
  description = "Time management database user"
  value       = module.database.enabled ? var.services.time_mgmt.database.user : null
}

output "time_mgmt_db_name" {
  description = "Time management database name"
  value       = module.database.enabled ? var.services.time_mgmt.database.name : null
}

output "time_mgmt_db_password_secret" {
  description = "Secret name for time management database password"
  value       = module.database.enabled ? "primind-timemgmt-db-password" : null
}

# =============================================================================
# Cost Management Status
# =============================================================================

output "costly_resources_deleted" {
  description = "Whether costly resources (Cloud SQL, VPC Connector, Redis) are deleted"
  value       = var.delete_costly_resources
}

output "costly_resources_stopped" {
  description = "Whether costly resources (Cloud SQL) are stopped"
  value       = var.stop_costly_resources
}
