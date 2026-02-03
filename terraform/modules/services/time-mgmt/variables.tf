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
  default     = "timemgmt_db"
}

variable "database_user" {
  description = "Database user"
  type        = string
  default     = "timemgmt_user"
}
