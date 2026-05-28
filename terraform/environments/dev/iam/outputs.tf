output "sa_email" {
  value = module.iam.sa_email
}

output "github_actions_sa_email" {
  value = module.iam.github_actions_sa_email
}

output "workload_identity_provider" {
  value = module.iam.workload_identity_provider # google_iam_workload_identity_pool_provider.github_provider.name
}
