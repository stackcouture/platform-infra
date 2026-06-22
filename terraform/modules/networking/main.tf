# VPC 
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode
}

# Subnets 
resource "google_compute_subnetwork" "private_subnets" {
  name          = var.subnetwork_name
  ip_cidr_range = var.subnetwork_ip_cidr_range

  region  = var.region_name
  network = google_compute_network.vpc.id

  stack_type = "IPV4_ONLY"

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.30.0.0/20"
  }

  private_ip_google_access = true
}

# Firewall for Internal Communication
resource "google_compute_firewall" "allow_internal" {
  name    = var.allow_internal_firewall_rule_name 
  network = google_compute_network.vpc.id
  direction = "INGRESS"

  priority = 1000
  
  source_ranges = [
    var.subnetwork_ip_cidr_range,
    "10.20.0.0/16",
    "10.30.0.0/20"
  ]

  # allow {
  #   protocol = "all"
  # }    
  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }
}

# Firewall for external access SSH, ICMP 
# resource "google_compute_firewall" "allow_ssh" {
#   name    = var.allow_external_firewall_rule_name
#   network = google_compute_network.vpc.id
#   allow {
#     protocol = "icmp"
#   }
#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }
#   source_ranges = ["0.0.0.0/0"]
# }

# Firewall for GKE Communication
# resource "google_compute_firewall" "allow_gke" {
#   name = var.allow_gke_rule_name
#   network = google_compute_network.vpc.id
#   allow {
#     protocol = "tcp"
#     ports    = ["443", "10250"]
#   }
#   source_ranges = ["0.0.0.0/0"]
# }

# Cloud Router
resource "google_compute_router" "nat_router" {
  name    = "${var.vpc_name}-router"
  region  = var.region_name
  network = google_compute_network.vpc.id
}

# Cloud NAT
resource "google_compute_router_nat" "cloud_nat" {
  name                               = "${var.vpc_name}-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region_name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}