data "google_client_config" "current" {}

module "iam" {
  source      = "../../../modules/iam"
  project_id  = data.google_client_config.current.project
  region_name = var.region_name

  github_org             = var.github_org
  github_repo            = var.github_repo
  pool_id                = var.pool_id
  provider_id            = var.provider_id
  service_account_id     = var.service_account_id
  artifact_registry_role = var.artifact_registry_role
}