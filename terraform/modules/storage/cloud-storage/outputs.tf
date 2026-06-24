output "bucket_output_name" {
  value = google_storage_bucket.bucket.name
}

output "artifact_bucket_output_name" {
  value = google_storage_bucket.artifact_repo_bucket.name
}

# output "iam_bucket_output_name" {
#   value = google_storage_bucket.iam_state_bucket.name
# }

output "networking_bucket_output_name" {
  value = google_storage_bucket.networking_state_bucket.name
}

output "platform_bucket_output_name" {
  value = google_storage_bucket.platform_terraform_state_bucket.name
}

# Velero buckup bucket
output "velero_backup_bucket" {
  value = google_storage_bucket.velero_backup_bucket.name
}