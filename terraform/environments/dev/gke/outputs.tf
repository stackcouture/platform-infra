output "cluster_endpoint" {
  value = module.gke.cluster_endpoint # google_container_cluster.demo_cluster.endpoint
}

output "cluster_name" {
  value = module.gke.cluster_name # google_container_cluster.demo_cluster.id
}

output "cluster_ca_certificate" {
  value = module.gke.cluster_ca_certificate # google_container_cluster.demo_cluster.master_auth[0].cluster_ca_certificate
}