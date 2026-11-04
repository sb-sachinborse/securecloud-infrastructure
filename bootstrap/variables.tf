variable "project_id" {
  description = "Existing GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-south1"
}

variable "state_bucket_name" {
  description = "Globally unique Terraform state bucket name"
  type        = string
}

variable "github_repository_id" {
  description = "Numeric GitHub repository ID"
  type        = string
}

variable "github_owner_id" {
  description = "Numeric GitHub owner ID"
  type        = string
}