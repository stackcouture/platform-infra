output "subnet_name" {
  value = google_compute_subnetwork.private_subnets.name
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}