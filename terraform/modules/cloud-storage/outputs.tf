output "bucket_output_name" {
  value = google_storage_bucket.bucket.name
}

output "artifact_bucket_output_name" {
  value = google_storage_bucket.artifact_repo_bucket.name
}

output "iam_bucket_output_name" {
  value = google_storage_bucket.iam_state_bucket.name
}