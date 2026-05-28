data "google_artifact_registry_repository" "repo" {
  project       = var.project_id
  location      = var.region_name
  repository_id = "vote-docker-repo"
}

data "google_project" "current" {
  project_id = var.project_id
}