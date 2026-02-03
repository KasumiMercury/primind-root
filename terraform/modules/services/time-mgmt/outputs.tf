output "service_url" {
  description = "Time management service URL"
  value       = google_cloud_run_v2_service.time_mgmt.uri
}

output "service_name" {
  description = "Time management service name"
  value       = google_cloud_run_v2_service.time_mgmt.name
}

output "service_account_email" {
  description = "Time management service account email"
  value       = google_service_account.time_mgmt.email
}

output "pubsub_topic_id" {
  description = "Pub/Sub topic ID for remind events"
  value       = google_pubsub_topic.remind_events.id
}

output "pubsub_topic_name" {
  description = "Pub/Sub topic name for remind events"
  value       = google_pubsub_topic.remind_events.name
}
