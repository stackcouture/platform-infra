data "google_client_config" "current" {}

module "gke" {
  source                   = "./modules/gke"
  compute_network_name     = module.vpc.vpc_name
  compute_subnetwork_name  = module.subnets.subnet_name
  sa_node_email            = module.sa.sa_email
  initial_node_count       = var.initial_node_count
  deletion_protection      = var.deletion_protection
  remove_default_node_pool = var.remove_default_node_pool
  location_name            = var.location_name
  project_id               = data.google_client_config.current.project
}