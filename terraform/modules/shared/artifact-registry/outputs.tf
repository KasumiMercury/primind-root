output "repository_id" {
  description = "The ID of the Artifact Registry repository"
  value       = google_artifact_registry_repository.ghcr_proxy.id
}

output "repository_name" {
  description = "The name of the Artifact Registry repository"
  value       = google_artifact_registry_repository.ghcr_proxy.name
}

output "repository_url" {
  description = "The URL for pulling images"
  value       = "${var.location}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}
