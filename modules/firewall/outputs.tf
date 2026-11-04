output "internal_firewall_name" {
  description = "Internal firewall rule name"
  value       = google_compute_firewall.allow_internal.name
}

output "iap_ssh_firewall_name" {
  description = "IAP SSH firewall rule name"
  value       = google_compute_firewall.allow_iap_ssh.name
}