output "cluster_endpoint" {
  value = google_container_cluster.demo_cluster.endpoint
}

output "cluster_name" {
  value = google_container_cluster.demo_cluster.name
}

output "cluster_ca_certificate" {
  value = google_container_cluster.demo_cluster.master_auth[0].cluster_ca_certificate
}