variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "artifact_registry_url" {
  description = "Artifact Registry repository URL"
  type        = string
}

variable "vpc_connector_id" {
  description = "VPC Access connector ID"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "cpu" {
  description = "CPU limit"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory limit"
  type        = string
  default     = "512Mi"
}

# Database
variable "sql_instance_name" {
  description = "Cloud SQL instance name"
  type        = string
}

variable "database_private_ip" {
  description = "Cloud SQL private IP"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "primind_db"
}

variable "database_user" {
  description = "Database user"
  type        = string
  default     = "primind_user"
}

# Redis
variable "redis_host" {
  description = "Redis host"
  type        = string
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

variable "redis_auth_secret_id" {
  description = "Secret Manager secret ID for Redis auth"
  type        = string
}

variable "redis_tls_enabled" {
  description = "Whether to use TLS for Redis connection"
  type        = bool
  default     = true
}

# OIDC
variable "oidc_google_client_id" {
  description = "Google OIDC client ID"
  type        = string
  sensitive   = true
}

variable "oidc_google_client_secret" {
  description = "Google OIDC client secret"
  type        = string
  sensitive   = true
}

variable "oidc_google_redirect_uri" {
  description = "Google OIDC redirect URI"
  type        = string
}

# Inter-service dependencies
variable "time_mgmt_url" {
  description = "Time management service URL"
  type        = string
}

variable "time_mgmt_service_name" {
  description = "Time management Cloud Run service name (for IAM binding)"
  type        = string
}
