# Provider Settings 
region_name = "asia-south1"

# Cloud Storage
bucket_name   = "terraform-dev-gke-state-bkt"
location      = "asia-south1"
storage_class = "STANDARD"
environment   = "dev"

# Artifact Storage Bucket 
artifact_bucket_name = "artifact-dev-state-bkt"

# IAM State Bucket 
# iam_state_bucket_name = "iam-dev-state-bucket"

# Networking State Bucket 
networking_state_bucket = "networking-dev-state-bucket"

# platform_terraform_state
platform_terraform_state = "stackcouture-platform-tf-state"

# Velero-terraform-state 
velero_backup_bucket_name = "stackcouture-velero-backups"

# Loki bucket 
loki_bucket_name = "loki-storage-stackcouture"