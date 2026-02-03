# Artifact Registry Remote Repository for GHCR
resource "google_artifact_registry_repository" "ghcr_proxy" {
  project       = var.project_id
  location      = var.location
  repository_id = var.repository_id
  description   = var.description
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"

  remote_repository_config {
    description = "Proxy for GitHub Container Registry"
    docker_repository {
      custom_repository {
        uri = "https://ghcr.io"
      }
    }
  }
}
