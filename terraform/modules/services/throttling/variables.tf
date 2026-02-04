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

# Inter-service dependencies
variable "notification_invoker_url" {
  description = "Notification invoker service URL"
  type        = string
}

variable "notification_invoker_service_name" {
  description = "Notification invoker Cloud Run service name (for IAM binding)"
  type        = string
}

variable "time_mgmt_url" {
  description = "Time management service URL"
  type        = string
}

variable "time_mgmt_service_name" {
  description = "Time management Cloud Run service name (for IAM binding)"
  type        = string
}

variable "remind_events_topic_id" {
  description = "Pub/Sub topic ID for remind events"
  type        = string
}

# Scheduler
variable "scheduler_schedule" {
  description = "Cron schedule for throttle job (e.g., '*/5 * * * *' for every 5 minutes)"
  type        = string
  default     = "*/5 * * * *"
}

variable "scheduler_paused" {
  description = "Whether to pause the Cloud Scheduler job (for hibernation mode)"
  type        = bool
  default     = false
}
