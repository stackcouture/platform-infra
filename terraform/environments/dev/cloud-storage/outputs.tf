output "bucket_name" {
  value = module.cloud_storage.bucket_output_name
}

output "artifact_bucket_name" {
  value = module.cloud_storage.artifact_bucket_output_name
}
