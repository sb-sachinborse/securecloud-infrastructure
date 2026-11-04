variable "project_id" {
  description = "GCP Development project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-south1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# variable "enable_flow_logs" {
#   description = "Enable VPC Flow Logs"
#   type        = bool
#   default     = false
# }