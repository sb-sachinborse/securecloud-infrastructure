
# Allow only required internal TCP and UDP ports
resource "google_compute_firewall" "allow_internal" {
  project     = var.project_id
  name        = "${var.firewall_prefix}-allow-internal"
  network     = var.network_self_link
  description = "Allow selected internal application traffic"

  direction = "INGRESS"
  priority  = 1000

  source_ranges = var.internal_source_ranges

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8000", "8080"]
  }

  allow {
    protocol = "udp"
    ports    = ["53", "123"]
  }
}

# SSH access only through Google Cloud IAP
resource "google_compute_firewall" "allow_iap_ssh" {
  project     = var.project_id
  name        = "${var.firewall_prefix}-allow-iap-ssh"
  network     = var.network_self_link
  description = "Allow SSH only through Google IAP"

  direction = "INGRESS"
  priority  = 900

  source_ranges = [var.iap_source_range]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
