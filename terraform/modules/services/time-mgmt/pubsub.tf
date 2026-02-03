# Pub/Sub topic for remind events
resource "google_pubsub_topic" "remind_events" {
  project = var.project_id
  name    = "remind-events"

  message_retention_duration = "604800s" # 7 days
}
