variable "project_id" {
  description = "GCP project ID (for Secret Manager)"
  type        = string
}

variable "name" {
  description = "Name of the Redis database"
  type        = string
  default     = "primind-redis"
}

variable "primary_region" {
  description = "Upstash primary region for global database (e.g., ap-northeast-1 for Tokyo)"
  type        = string
  default     = "ap-northeast-1"
}

variable "tls" {
  description = "Enable TLS encryption (required for Upstash)"
  type        = bool
  default     = true
}

variable "eviction" {
  description = "Enable eviction when memory is full"
  type        = bool
  default     = true
}

# Cost management
variable "enabled" {
  description = "Whether to create the Redis database"
  type        = bool
  default     = true
}
