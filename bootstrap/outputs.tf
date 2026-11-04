output "project_id" {
  value = var.project_id
}

output "project_number" {
  value = data.google_project.current.number
}

output "terraform_state_bucket" {
  value = google_storage_bucket.terraform_state.name
}

output "terraform_service_account" {
  value = google_service_account.terraform_deployer.email
}

output "workload_identity_pool" {
  value = google_iam_workload_identity_pool.github.name
}

output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.github.name
}