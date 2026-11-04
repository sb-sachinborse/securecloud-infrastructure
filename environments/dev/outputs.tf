output "project_id" {
  value       = var.project_id
  description = "Development GCP project"
}

output "vpc_name" {
  value       = module.networking.network_name
  description = "Development VPC"
}

output "vpc_self_link" {
  value       = module.networking.network_self_link
  description = "Development VPC self link"
}

output "subnet_name" {
  value       = module.networking.subnet_name
  description = "Development subnet"
}

output "subnet_cidr" {
  value       = module.networking.subnet_cidr
  description = "Development subnet CIDR"
}

output "gke_pods_range" {
  value       = module.networking.pods_range_name
  description = "Reserved GKE Pods range"
}

output "gke_services_range" {
  value       = module.networking.services_range_name
  description = "Reserved GKE Services range"
}

output "firewall_internal_rule" {
  value       = module.firewall.internal_firewall_name
  description = "Internal firewall rule"
}

output "firewall_iap_ssh_rule" {
  value       = module.firewall.iap_ssh_firewall_name
  description = "IAP SSH firewall rule"
}

output "cloud_router" {
  value       = module.cloud_nat.router_name
  description = "Cloud Router"
}

output "cloud_nat" {
  value       = module.cloud_nat.nat_name
  description = "Cloud NAT"
}