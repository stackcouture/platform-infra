data "google_client_config" "current" {}

data "terraform_remote_state" "networking" {
  backend = "gcs"
  config = {
    bucket = "stackcouture-platform-tf-state"
    prefix = "dev/networking"
  }
}

module "cloud_sql" {
  source            = "../../../modules/cloud-sql"
  project_id        = var.project_id
  region_name       = var.region_name
  network_self_link = data.terraform_remote_state.networking.outputs.network_self_link
  instance_name     = var.instance_name # "postgres-prod"
  database_name     = var.database_name # "votingapp"
  db_tier           = var.db_tier
  zone_name         = var.zone_name
  db_version        = var.db_version
}