data "google_client_config" "current" {}

module "artifact_registry" {
  source                 = "../../../../modules/storage/artifact-registry"
  project_id             = data.google_client_config.current.project
  region_name            = var.region_name
  repository_name        = var.repository_name
  repository_description = var.repository_description
  repository_format      = var.repository_format

  platform_repository_name        = var.platform_repository_name
  platform_repository_description = var.platform_repository_description
  platform_repository_format      = var.platform_repository_format
}
