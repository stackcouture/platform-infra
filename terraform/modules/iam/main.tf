resource "google_service_account" "gke_nodes" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
}

resource "google_project_iam_member" "gke_node_logging" {
  project = var.project_id 
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_node_monitoring" {
  project = var.project_id 
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_node_monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_node_service_account_role" {
  project = var.project_id
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_node_storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_artifact_registry_repository_iam_member" "repo_reader" {
  project    = var.project_id
  location   = var.region_name
  repository = data.google_artifact_registry_repository.repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Service Account for Secrets 
resource "google_service_account" "eso_gsa" {
  account_id   = "eso-gsa"
  display_name = "External Secrets Operator GSA"
}

resource "google_project_iam_member" "secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.eso_gsa.email}"
}

resource "google_service_account_iam_member" "workload_identity" {
  service_account_id = google_service_account.eso_gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[external-secrets/external-secrets]"
}

# Service Accounts for github actions 
resource "google_project_service" "required_services" {
  for_each = toset([
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "artifactregistry.googleapis.com",
  ])
  project = var.project_id
  service = each.value
  disable_on_destroy = false
}

resource "google_service_account" "github_actions" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "GitHub Actions"
}

resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project_id
  role    = var.artifact_registry_role
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_id
  display_name = "GitHub Pool"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id

  display_name = "GitHub Provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }

  attribute_condition = <<EOT
  attribute.repository == "stackcouture/voting-app" ||
  attribute.repository == "stackcouture/platform-infra"
EOT

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# resource "google_service_account_iam_member" "wif_user" {
#   service_account_id = google_service_account.github_actions.name
#   role = "roles/iam.workloadIdentityUser"
#   member = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/attribute.repository/${var.github_org}/${var.github_repo}"
# }

resource "google_service_account_iam_member" "voting_app_wif_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/attribute.repository/stackcouture/voting-app"
}

resource "google_service_account_iam_member" "platform_infra_wif_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_pool.workload_identity_pool_id}/attribute.repository/stackcouture/platform-infra"
}

###############   Kubecost ##############################
# GCP Service Account for kubecost 
resource "google_service_account" "kubecost_gsa" {
  account_id   = "kubecost-gsa"
  display_name = "Kubecost GSA"
}

# Compute Viewer
resource "google_project_iam_member" "kubecost_compute_viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.kubecost_gsa.email}"
}

# General Viewer
resource "google_project_iam_member" "kubecost_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.kubecost_gsa.email}"
}

# resource "google_service_account_iam_member" "kubecost_workload_identity" {
#   service_account_id = google_service_account.kubecost_gsa.name
#   role = "roles/iam.workloadIdentityUser"
#   member = "serviceAccount:${var.project_id}.svc.id.goog[kubecost/kubecost]"
# }

resource "google_service_account_iam_member" "kubecost_workload_identity" {
  service_account_id = google_service_account.kubecost_gsa.name
  role               = "roles/iam.workloadIdentityUser"

  member = "serviceAccount:${var.project_id}.svc.id.goog[kubecost/kubecost-cost-analyzer]"
}



