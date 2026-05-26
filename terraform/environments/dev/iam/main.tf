data "google_client_config" "current" {}

module "iam" {
  source      = "../../../modules/iam"
  project_id  = data.google_client_config.current.project
  region_name = var.region_name
}