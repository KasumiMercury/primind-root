output "vpc_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "The self link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = google_compute_subnetwork.private.id
}

output "private_subnet_name" {
  description = "The name of the private subnet"
  value       = google_compute_subnetwork.private.name
}

output "vpc_connector_id" {
  description = "The ID of the VPC Access connector"
  value       = var.vpc_connector_enabled ? google_vpc_access_connector.connector[0].id : null
}

output "vpc_connector_name" {
  description = "The name of the VPC Access connector"
  value       = var.vpc_connector_enabled ? google_vpc_access_connector.connector[0].name : null
}

output "vpc_connector_enabled" {
  description = "Whether the VPC Access connector is enabled"
  value       = var.vpc_connector_enabled
}

output "private_vpc_connection" {
  description = "The private VPC connection for managed services"
  value       = google_service_networking_connection.private_vpc_connection.id
}
