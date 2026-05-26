module "networking" {
  source                  = "../../../modules/networking"
  vpc_name                = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode

  subnetwork_name          = var.subnetwork_name
  subnetwork_ip_cidr_range = var.subnetwork_ip_cidr_range
  region_name              = var.region_name

  allow_internal_firewall_rule_name = var.allow_internal_firewall_rule_name
  allow_external_firewall_rule_name = var.allow_external_firewall_rule_name
  allow_gke_rule_name               = var.allow_gke_rule_name
}
