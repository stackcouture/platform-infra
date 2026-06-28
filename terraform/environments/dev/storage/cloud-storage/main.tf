module "cloud_storage" {
  source               = "../../../../modules/storage/cloud-storage"
  bucket_name          = var.bucket_name
  location             = var.location
  storage_class        = var.storage_class
  environment          = var.environment
  artifact_bucket_name = var.artifact_bucket_name
  # iam_state_bucket_name    = var.iam_state_bucket_name
  networking_state_bucket   = var.networking_state_bucket
  platform_terraform_state  = var.platform_terraform_state
  velero_backup_bucket_name = var.velero_backup_bucket_name
  loki_bucket_name          = var.loki_bucket_name
  project_id                = var.project_id
}