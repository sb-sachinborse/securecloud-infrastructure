# Get current GCP project information

data "google_project" "current" {
  project_id = var.project_id
}


# Enable required APIs

locals {
  required_apis = [
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

resource "google_project_service" "apis" {

  for_each = toset(local.required_apis)

  project = var.project_id
  service = each.value

  disable_on_destroy = false
}


# Terraform Remote State Bucket

resource "google_storage_bucket" "terraform_state" {

  name     = var.state_bucket_name
  project  = var.project_id
  location = var.region

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"

  force_destroy = false

  versioning {
    enabled = true
  }

  labels = {
    project     = "securecloud"
    environment = "shared"
    managed_by  = "terraform"
    purpose     = "terraform-state"
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    google_project_service.apis
  ]

  logging {
    log_bucket = google_storage_bucket.terraform_state_logs.name
  }
}

# Dedicated bucket for Terraform state bucket access logs
# Dedicated bucket for Terraform state bucket access logs
resource "google_storage_bucket" "terraform_state_logs" {
  name                        = "${var.state_bucket_name}-access-logs"
  project                     = var.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  labels = {
    project     = "securecloud"
    environment = "shared"
    managed_by  = "terraform"
    purpose     = "terraform-state-access-logs"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Allow the Cloud Storage logging service to write access logs
resource "google_storage_bucket_iam_member" "terraform_state_logs_writer" {
  bucket = google_storage_bucket.terraform_state_logs.name
  role   = "roles/storage.objectCreator"

  member = "group:cloud-storage-analytics@google.com"
}


# Terraform Deployment Service Account

resource "google_service_account" "terraform_deployer" {

  project      = var.project_id
  account_id   = "securecloud-terraform"
  display_name = "SecureCloud Terraform Deployment"

  description = "Identity used by GitHub Actions to deploy infrastructure"
}


# Workload Identity Pool

resource "google_iam_workload_identity_pool" "github" {

  project = var.project_id

  workload_identity_pool_id = "securecloud-github-pool"

  display_name = "SecureCloud GitHub Pool"

  description = "Identity pool for GitHub Actions"
}


# GitHub OIDC Provider


resource "google_iam_workload_identity_pool_provider" "github" {
  project = var.project_id

  workload_identity_pool_id = (
    google_iam_workload_identity_pool.github.workload_identity_pool_id
  )

  workload_identity_pool_provider_id = "github-provider"

  display_name = "GitHub Actions OIDC"

  attribute_mapping = {
    "google.subject"                = "assertion.sub"
    "attribute.repository_id"       = "assertion.repository_id"
    "attribute.repository_owner_id" = "assertion.repository_owner_id"
    "attribute.repository"          = "assertion.repository"
    "attribute.repository_owner"    = "assertion.repository_owner"
  }

  attribute_condition = <<-EOT
    assertion.sub == "repo:${var.github_owner}/${var.github_repository}:ref:refs/heads/main" &&
    assertion.repository_owner_id == "${var.github_owner_id}" &&
    assertion.repository_id == "${var.github_repository_id}" &&
    assertion.repository == "${var.github_repository}" &&
    assertion.repository_owner == "${var.github_owner}" &&
    assertion.ref == "refs/heads/main" &&
    assertion.ref_type == "branch"
  EOT

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}



# Allow only the specified GitHub repository
# to impersonate the Terraform deployment SA

resource "google_service_account_iam_member" "github_wif" {

  service_account_id = (
    google_service_account.terraform_deployer.name
  )

  role = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository_id/${var.github_repository_id}"
}