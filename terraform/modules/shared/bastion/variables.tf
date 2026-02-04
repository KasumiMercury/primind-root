variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "" # Will be auto-set to region-a if empty
}

variable "enabled" {
  description = "Whether to create the bastion VM"
  type        = bool
  default     = false
}

variable "vpc_name" {
  description = "VPC network name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name for the bastion"
  type        = string
}

variable "machine_type" {
  description = "Machine type for bastion"
  type        = string
  default     = "e2-micro"
}

variable "database_private_ip" {
  description = "Cloud SQL private IP"
  type        = string
  default     = ""
}
