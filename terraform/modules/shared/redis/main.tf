# Upstash Redis Database (Global)
resource "upstash_redis_database" "redis" {
  database_name  = var.name
  region         = "global"
  primary_region = var.primary_region
  tls            = var.tls
  eviction       = var.eviction
}

# Store Upstash Redis password in GCP Secret Manager for Cloud Run access
resource "google_secret_manager_secret" "redis_auth" {
  project   = var.project_id
  secret_id = "primind-redis-auth"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "redis_auth" {
  secret      = google_secret_manager_secret.redis_auth.id
  secret_data = upstash_redis_database.redis.password
}
