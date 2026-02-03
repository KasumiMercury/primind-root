variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "location" {
  description = "Repository location"
  type        = string
}

variable "repository_id" {
  description = "Repository ID"
  type        = string
  default     = "primind-ghcr"
}

variable "description" {
  description = "Repository description"
  type        = string
  default     = "Remote repository proxying GitHub Container Registry"
}
