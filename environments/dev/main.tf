locals {
  name_prefix = "securecloud-${var.environment}"

  common_labels = {
    project     = "securecloud"
    environment = var.environment
    managed_by  = "terraform"
  }
}

# --------------------------------------------------
# NETWORKING MODULE
# --------------------------------------------------

module "networking" {
  source = "../../modules/networking"

  project_id   = var.project_id
  environment  = var.environment
  network_name = "${local.name_prefix}-vpc"
  subnet_name  = "${local.name_prefix}-subnet"
  region       = var.region

  subnet_cidr   = "10.10.1.0/24"
  pods_cidr     = "10.20.0.0/16"
  services_cidr = "10.30.0.0/20"

  # enable_flow_logs = var.enable_flow_logs
}

# --------------------------------------------------
# FIREWALL MODULE
# --------------------------------------------------

module "firewall" {
  source = "../../modules/firewall"

  project_id      = var.project_id
  environment     = var.environment
  firewall_prefix = local.name_prefix

  network_self_link = module.networking.network_self_link

  internal_source_ranges = [
    "10.10.1.0/24",
    "10.20.0.0/16",
    "10.30.0.0/20"
  ]

  iap_source_range = "35.235.240.0/20"
}

# --------------------------------------------------
# CLOUD NAT MODULE
# --------------------------------------------------

module "cloud_nat" {
  source = "../../modules/cloud-nat"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  network_self_link = module.networking.network_self_link

  router_name = "${local.name_prefix}-router"
  nat_name    = "${local.name_prefix}-nat"
}