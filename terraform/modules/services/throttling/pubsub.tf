# Push subscription for remind.cancelled events
resource "google_pubsub_subscription" "remind_cancelled" {
  project = var.project_id
  name    = "remind-events-cancelled-throttling"
  topic   = var.remind_events_topic_id

  filter = "attributes.event_type = \"remind.cancelled\""

  push_config {
    push_endpoint = "${google_cloud_run_v2_service.throttling.uri}/api/v1/remind/cancel"

    oidc_token {
      service_account_email = google_service_account.pubsub_invoker.email
    }
  }

  ack_deadline_seconds       = 30
  message_retention_duration = "604800s" # 7 days
  retain_acked_messages      = false

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  expiration_policy {
    ttl = "" # Never expire
  }
}
