output "service_url" {
  description = "Throttling service URL"
  value       = google_cloud_run_v2_service.throttling.uri
}

output "service_name" {
  description = "Throttling service name"
  value       = google_cloud_run_v2_service.throttling.name
}

output "service_account_email" {
  description = "Throttling service account email"
  value       = google_service_account.throttling.email
}

output "invoke_queue_name" {
  description = "Invoke Cloud Tasks queue name"
  value       = google_cloud_tasks_queue.invoke.name
}
