terraform {
  required_version = ">= 1.5.0" # 1.17.0 local version

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.10.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.project_id
  region  = var.region
}