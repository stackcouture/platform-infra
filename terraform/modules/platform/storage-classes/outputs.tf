output "name" {
  value = kubernetes_storage_class.premium_rwo_v2.metadata[0].name
}