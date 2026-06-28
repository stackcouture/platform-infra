data "google_artifact_registry_repository" "repo" {
  project       = var.project_id
  location      = var.region_name
  repository_id = "vote-docker-repo"
}

data "google_artifact_registry_repository" "platform_repo" {
  project       = var.project_id
  location      = var.region_name
  repository_id = "platform-automation-repo"
}

data "google_project" "current" {
  project_id = var.project_id
}

data "google_secret_manager_secret" "postgres_password" {
  secret_id = "postgres-password"
}