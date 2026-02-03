output "service_url" {
  description = "Central backend service URL"
  value       = google_cloud_run_v2_service.central_backend.uri
}

output "service_name" {
  description = "Central backend service name"
  value       = google_cloud_run_v2_service.central_backend.name
}

output "service_account_email" {
  description = "Central backend service account email"
  value       = google_service_account.central_backend.email
}

output "remind_register_queue_name" {
  description = "Remind register Cloud Tasks queue name"
  value       = google_cloud_tasks_queue.remind_register.name
}

output "remind_cancel_queue_name" {
  description = "Remind cancel Cloud Tasks queue name"
  value       = google_cloud_tasks_queue.remind_cancel.name
}
