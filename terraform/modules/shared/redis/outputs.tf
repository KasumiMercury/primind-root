output "host" {
  description = "The endpoint hostname of the Upstash Redis database"
  value       = upstash_redis_database.redis.endpoint
  sensitive   = true
}

output "port" {
  description = "The port of the Upstash Redis database"
  value       = upstash_redis_database.redis.port
}

output "auth_string" {
  description = "The password of the Upstash Redis database"
  value       = upstash_redis_database.redis.password
  sensitive   = true
}

output "auth_secret_id" {
  description = "Secret Manager secret ID for Redis auth"
  value       = google_secret_manager_secret.redis_auth.secret_id
}

output "connection_string" {
  description = "The connection string (host:port)"
  value       = "${upstash_redis_database.redis.endpoint}:${upstash_redis_database.redis.port}"
  sensitive   = true
}

output "name" {
  description = "The name of the Upstash Redis database"
  value       = upstash_redis_database.redis.database_name
}

output "database_id" {
  description = "The Upstash database ID"
  value       = upstash_redis_database.redis.database_id
}

output "tls_enabled" {
  description = "Whether TLS is enabled for the Redis connection"
  value       = upstash_redis_database.redis.tls
}
