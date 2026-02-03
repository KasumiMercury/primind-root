variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "primind-vpc"
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "connector_cidr" {
  description = "CIDR range for the VPC Access connector"
  type        = string
  default     = "10.8.0.0/28"
}

variable "connector_machine_type" {
  description = "Machine type for VPC Access connector instances"
  type        = string
  default     = "e2-micro"
}

variable "connector_min_instances" {
  description = "Minimum number of VPC connector instances"
  type        = number
  default     = 2
}

variable "connector_max_instances" {
  description = "Maximum number of VPC connector instances"
  type        = number
  default     = 3
}

variable "psc_ip_range" {
  description = "IP range for Private Service Connection"
  type        = string
  default     = "10.64.0.0/16"
}
