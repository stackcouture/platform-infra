data "google_client_config" "current" {}

module "artifact_registry" {
  source                 = "../../../../modules/storage/artifact-registry"
  project_id             = data.google_client_config.current.project
  region_name            = var.region_name
  repository_name        = var.repository_name
  repository_description = var.repository_description
  repository_format      = var.repository_format
}
