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
  value       = module.central_backend.service_url
}

output "time_mgmt_url" {
  description = "Time management service URL"
  value       = module.time_mgmt.service_url
}

output "throttling_url" {
  description = "Throttling service URL"
  value       = module.throttling.service_url
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
  value       = module.central_backend.service_name
}

output "time_mgmt_name" {
  description = "Time management service name"
  value       = module.time_mgmt.service_name
}

output "throttling_name" {
  description = "Throttling service name"
  value       = module.throttling.service_name
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
  value       = module.central_backend.service_account_email
}

output "time_mgmt_service_account" {
  description = "Time management service account email"
  value       = module.time_mgmt.service_account_email
}

output "throttling_service_account" {
  description = "Throttling service account email"
  value       = module.throttling.service_account_email
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
  value       = module.time_mgmt.pubsub_topic_name
}

output "remind_register_queue" {
  description = "Remind register Cloud Tasks queue name"
  value       = module.central_backend.remind_register_queue_name
}

output "remind_cancel_queue" {
  description = "Remind cancel Cloud Tasks queue name"
  value       = module.central_backend.remind_cancel_queue_name
}

output "invoke_queue" {
  description = "Invoke Cloud Tasks queue name"
  value       = module.throttling.invoke_queue_name
}
