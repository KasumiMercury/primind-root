# =============================================================================
# Project Configuration
# =============================================================================
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "project_number" {
  description = "GCP project number"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-northeast2"
}

# =============================================================================
# Shared Infrastructure Configuration
# =============================================================================
variable "database" {
  description = "Cloud SQL configuration"
  type = object({
    tier      = optional(string, "db-f1-micro")
    disk_size = optional(number, 10)
    disk_type = optional(string, "PD_HDD")
  })
  default = {}
}

variable "redis" {
  description = "Upstash Redis configuration"
  type = object({
    primary_region = optional(string, "ap-northeast-1")
    tls            = optional(bool, true)
    eviction       = optional(bool, true)
  })
  default = {}
}

# =============================================================================
# Upstash Configuration
# =============================================================================
variable "upstash_email" {
  description = "Upstash account email for API authentication"
  type        = string
  sensitive   = true
}

variable "upstash_api_key" {
  description = "Upstash API key for API authentication"
  type        = string
  sensitive   = true
}

# =============================================================================
# Per-Service Configuration
# =============================================================================
variable "services" {
  description = "Per-service configuration"
  type = object({
    central_backend = object({
      image_tag     = string
      min_instances = optional(number, 0)
      max_instances = optional(number, 3)
      cpu           = optional(string, "1")
      memory        = optional(string, "512Mi")
      database = optional(object({
        name = optional(string, "primind_db")
        user = optional(string, "primind_user")
      }), {})
    })
    time_mgmt = object({
      image_tag     = string
      min_instances = optional(number, 0)
      max_instances = optional(number, 3)
      cpu           = optional(string, "1")
      memory        = optional(string, "512Mi")
      database = optional(object({
        name = optional(string, "timemgmt_db")
        user = optional(string, "timemgmt_user")
      }), {})
    })
    throttling = object({
      image_tag     = string
      min_instances = optional(number, 0)
      max_instances = optional(number, 3)
      cpu           = optional(string, "1")
      memory        = optional(string, "512Mi")
    })
    notification_invoker = object({
      image_tag     = string
      min_instances = optional(number, 0)
      max_instances = optional(number, 5)
      cpu           = optional(string, "1")
      memory        = optional(string, "512Mi")
    })
  })
}

# =============================================================================
# Authentication & Secrets (OIDC credentials from Google)
# =============================================================================
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

# =============================================================================
# External URLs
# =============================================================================
variable "web_app_url" {
  description = "Web application URL (deployed to Cloudflare Workers)"
  type        = string
}

# =============================================================================
# Cost Management
# =============================================================================
variable "delete_costly_resources" {
  description = "Delete costly resources (Cloud SQL, VPC Connector, Redis). WARNING: Data will be lost!"
  type        = bool
  default     = false
}

variable "stop_costly_resources" {
  description = "Stop costly resources (Cloud SQL only). Data is preserved but services won't work."
  type        = bool
  default     = false
}

# =============================================================================
# Migration Configuration
# =============================================================================
variable "enable_bastion" {
  description = "Enable bastion VM for database migrations. Managed via task commands."
  type        = bool
  default     = false
}