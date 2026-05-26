data "google_client_config" "current" {}

data "terraform_remote_state" "networking" {
  backend = "gcs"
  config = {
    bucket = "networking-dev-state-bucket"
    prefix = "dev/networking-state"
  }
}

data "terraform_remote_state" "iam" {
  backend = "gcs"
  config = {
    bucket = "iam-dev-state-bucket"
    prefix = "dev/iam-state"
  }
}

module "gke" {
  source                   = "../../../modules/gke"
  compute_network_name     = data.terraform_remote_state.networking.outputs.vpc_name
  compute_subnetwork_name  = data.terraform_remote_state.networking.outputs.subnet_name
  sa_node_email            = data.terraform_remote_state.iam.outputs.sa_email
  initial_node_count       = var.initial_node_count
  deletion_protection      = var.deletion_protection
  remove_default_node_pool = var.remove_default_node_pool
  location_name            = var.location_name
  project_id               = data.google_client_config.current.project
}