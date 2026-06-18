output "vpc_name" {
  value = module.networking.vpc_name
}

output "subnet_name" {
  value = module.networking.subnet_name
}

output "network_self_link" {
  value = module.networking.network_self_link # google_compute_network.vpc.self_link
}