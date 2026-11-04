variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "subnet_cidr" {
  description = "Primary subnet CIDR"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary CIDR reserved for GKE Pods"
  type        = string
}

variable "services_cidr" {
  description = "Secondary CIDR reserved for GKE Services"
  type        = string
}

# variable "enable_flow_logs" {
#   description = "Enable VPC flow logs"
#   type        = bool
#   default     = false
# }

variable "environment" {
  description = "Environment name"
  type        = string
}