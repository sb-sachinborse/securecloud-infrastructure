
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  description = "SecureCloud ${var.environment} VPC"

  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "subnet" {
  project       = var.project_id
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr

  private_ip_google_access = true
  stack_type               = "IPV4_ONLY"

  description = "SecureCloud ${var.environment} private subnet"

  secondary_ip_range {
    range_name    = "${var.environment}-pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "${var.environment}-services"
    ip_cidr_range = var.services_cidr
  }

  # VPC Flow Logs enabled
  log_config {
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = 0.5
    metadata             = "EXCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "deny_all_ingress" {
  project     = var.project_id
  name        = "${var.network_name}-deny-all-ingress"
  network     = google_compute_network.vpc.id
  description = "Default-deny ingress security baseline"

  direction = "INGRESS"
  priority  = 65534

  source_ranges = ["0.0.0.0/0"]

  deny {
    protocol = "all"
  }
}