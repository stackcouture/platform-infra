# Provider Settings 
region_name = "asia-south1"
zone_name   = "asia-south1-a"

# VPC Settings 
vpc_name                = "dev-vpc"
auto_create_subnetworks = false
routing_mode            = "REGIONAL"

# Subnet 
subnetwork_name          = "private-subnet"
subnetwork_ip_cidr_range = "10.10.0.0/20"

# Firewall 
allow_internal_firewall_rule_name = "internal-firewall-rule"
allow_external_firewall_rule_name = "external-firewall-rule"
allow_gke_rule_name               = "gke-firewall-rule"