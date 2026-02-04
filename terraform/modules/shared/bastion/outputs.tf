output "instance_name" {
  description = "Bastion instance name"
  value       = var.enabled ? google_compute_instance.bastion[0].name : null
}

output "zone" {
  description = "Bastion zone"
  value       = var.enabled ? local.zone : null
}

output "ssh_command" {
  description = "Command to SSH to bastion via IAP"
  value       = var.enabled ? "gcloud compute ssh ${google_compute_instance.bastion[0].name} --zone=${local.zone} --tunnel-through-iap --project=${var.project_id}" : null
}

output "tunnel_command" {
  description = "Command to create SSH tunnel for database access"
  value       = var.enabled && var.database_private_ip != "" ? "gcloud compute ssh ${google_compute_instance.bastion[0].name} --zone=${local.zone} --tunnel-through-iap --project=${var.project_id} -- -N -L 5432:${var.database_private_ip}:5432" : null
}

output "enabled" {
  description = "Whether bastion is enabled"
  value       = var.enabled
}
