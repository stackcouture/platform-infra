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

resource "google_project_iam_member" "github_actions_network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_container_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
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

resource "google_secret_manager_secret_iam_member" "cloudflare_token_access" {
  project   = var.project_id
  secret_id = "cloudflare-api-token"
  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.eso_gsa.email}"
}

# Postgres Secret Access
resource "google_secret_manager_secret_iam_member" "postgres_secret_access" {
  project   = var.project_id
  secret_id = data.google_secret_manager_secret.postgres_password.secret_id
  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.eso_gsa.email}"
}

# Github actions permission for buckets 
resource "google_storage_bucket_iam_member" "github_actions_tf_state" {
  bucket = "stackcouture-platform-tf-state"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:github-actions@project-18ee516c-a108-431d-a73.iam.gserviceaccount.com"
}

# Velero Service Account 
resource "google_service_account" "velero_gsa" {
  account_id   = "velero-gsa"
  display_name = "Velero Backup Service Account"
}

resource "google_project_iam_member" "velero_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.velero_gsa.email}"
}

resource "google_project_iam_member" "velero_compute_storage_admin" {
  project = var.project_id
  role    = "roles/compute.storageAdmin"
  member  = "serviceAccount:${google_service_account.velero_gsa.email}"
}

resource "google_service_account_iam_member" "velero_workload_identity" {
  service_account_id = google_service_account.velero_gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.project_id}.svc.id.goog[velero/velero]"
}

resource "google_storage_bucket_iam_member" "cloudsql_export" {
  bucket = "stackcouture-velero-backups"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:p440909314761-gxpqgj@gcp-sa-cloud-sql.iam.gserviceaccount.com"
}

# Loki Service Account 
resource "google_service_account" "loki_gsa" {
  account_id   = "loki-gsa"
  display_name = "Loki Service Account"
}

resource "google_storage_bucket_iam_member" "loki_storage" {
  bucket = "loki-storage-stackcouture"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.loki_gsa.email}"
}

resource "google_service_account_iam_member" "loki_workload_identity" {
  service_account_id = google_service_account.loki_gsa.name
  role = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.project_id}.svc.id.goog[logging/loki]"
}

