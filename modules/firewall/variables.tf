variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "network_self_link" {
  description = "VPC self link"
  type        = string
}

variable "firewall_prefix" {
  description = "Prefix for firewall rule names"
  type        = string
}

variable "internal_source_ranges" {
  description = "Internal CIDR ranges allowed to communicate"
  type        = list(string)
}

variable "iap_source_range" {
  description = "Google IAP TCP forwarding source range"
  type        = string
  default     = "35.235.240.0/20"
}

variable "environment" {
  description = "Environment name"
  type        = string
}