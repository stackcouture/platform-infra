output "artifact_name" {
  value = module.artifact_registry.repository_url
}

output "platform_artifact" {
  value = module.artifact_registry.platform_repository_url
}