output "host" {
  description = "The endpoint hostname of the Upstash Redis database"
  value       = var.enabled ? upstash_redis_database.redis[0].endpoint : null
  sensitive   = true
}

output "port" {
  description = "The port of the Upstash Redis database"
  value       = var.enabled ? upstash_redis_database.redis[0].port : null
}

output "auth_string" {
  description = "The password of the Upstash Redis database"
  value       = var.enabled ? upstash_redis_database.redis[0].password : null
  sensitive   = true
}

output "auth_secret_id" {
  description = "Secret Manager secret ID for Redis auth"
  value       = var.enabled ? google_secret_manager_secret.redis_auth[0].secret_id : null
}

output "connection_string" {
  description = "The connection string (host:port)"
  value       = var.enabled ? "${upstash_redis_database.redis[0].endpoint}:${upstash_redis_database.redis[0].port}" : null
  sensitive   = true
}

output "name" {
  description = "The name of the Upstash Redis database"
  value       = var.enabled ? upstash_redis_database.redis[0].database_name : null
}

output "database_id" {
  description = "The Upstash database ID"
  value       = var.enabled ? upstash_redis_database.redis[0].database_id : null
}

output "tls_enabled" {
  description = "Whether TLS is enabled for the Redis connection"
  value       = var.enabled ? upstash_redis_database.redis[0].tls : null
}

output "enabled" {
  description = "Whether the Redis database is enabled"
  value       = var.enabled
}
