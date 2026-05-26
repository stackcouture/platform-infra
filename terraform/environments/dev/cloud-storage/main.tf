module "cloud_storage" {
  source               = "../../modules/cloud-storage"
  bucket_name          = var.bucket_name
  location             = var.location
  storage_class        = var.storage_class
  environment          = var.environment
  artifact_bucket_name = var.artifact_bucket_name
}