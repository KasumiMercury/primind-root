# VPC Network
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Private Subnet for internal resources
resource "google_compute_subnetwork" "private" {
  project       = var.project_id
  name          = "${var.vpc_name}-private"
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Reserved IP range for Private Service Connection (Cloud SQL, Memorystore)
resource "google_compute_global_address" "private_ip_range" {
  project       = var.project_id
  name          = "${var.vpc_name}-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  address       = split("/", var.psc_ip_range)[0]
  network       = google_compute_network.vpc.id
}

# Private Service Connection for managed services
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

# Serverless VPC Access Connector for Cloud Run
resource "google_vpc_access_connector" "connector" {
  count = var.vpc_connector_enabled ? 1 : 0

  project       = var.project_id
  name          = "${var.vpc_name}-connector"
  region        = var.region
  ip_cidr_range = var.connector_cidr
  network       = google_compute_network.vpc.name

  machine_type  = var.connector_machine_type
  min_instances = var.connector_min_instances
  max_instances = var.connector_max_instances
}

# Firewall rule to allow internal communication
resource "google_compute_firewall" "allow_internal" {
  project = var.project_id
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.private_subnet_cidr, var.connector_cidr, var.psc_ip_range]
}

# Firewall rule to allow health checks from GCP
resource "google_compute_firewall" "allow_health_checks" {
  project = var.project_id
  name    = "${var.vpc_name}-allow-health-checks"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
  }

  # GCP health check IP ranges
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}
