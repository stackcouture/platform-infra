output "sa_email" {
  value = google_service_account.gke_nodes.email
}

output "github_actions_sa_email" {
  value = google_service_account.github_actions.email
}

output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.github_provider.name
}

output "kubecost_gsa_email" {
  value = google_service_account.kubecost_gsa.email
}

