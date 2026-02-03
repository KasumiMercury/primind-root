output "service_url" {
  description = "Notification invoker service URL"
  value       = google_cloud_run_v2_service.notification_invoker.uri
}

output "service_name" {
  description = "Notification invoker service name"
  value       = google_cloud_run_v2_service.notification_invoker.name
}

output "service_account_email" {
  description = "Notification invoker service account email"
  value       = google_service_account.notification_invoker.email
}
