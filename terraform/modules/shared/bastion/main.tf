locals {
  zone = var.zone != "" ? var.zone : "${var.region}-a"
}

# Service account for bastion (minimal permissions)
resource "google_service_account" "bastion" {
  count = var.enabled ? 1 : 0

  project      = var.project_id
  account_id   = "primind-bastion"
  display_name = "Primind Bastion Service Account"
}

# Bastion VM instance (tunnel only - no tools needed)
resource "google_compute_instance" "bastion" {
  count = var.enabled ? 1 : 0

  project      = var.project_id
  name         = "primind-bastion"
  machine_type = var.machine_type
  zone         = local.zone

  # Use spot/preemptible for cost savings
  scheduling {
    preemptible                 = true
    automatic_restart           = false
    provisioning_model          = "SPOT"
    instance_termination_action = "STOP"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    # No external IP - access via IAP only
  }

  service_account {
    email  = google_service_account.bastion[0].email
    scopes = ["cloud-platform"]
  }

  # Enable OS Login for IAP
  metadata = {
    enable-oslogin = "TRUE"
  }

  tags = ["bastion", "iap-ssh"]

  labels = {
    purpose = "migration-tunnel"
  }

  # Allow deletion
  deletion_protection = false
}

# Firewall rule to allow IAP SSH
resource "google_compute_firewall" "allow_iap_ssh" {
  count = var.enabled ? 1 : 0

  project = var.project_id
  name    = "primind-allow-iap-ssh"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # IAP's IP range
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]
}
