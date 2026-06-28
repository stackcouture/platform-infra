variable "bucket_name" {
  type        = string
  description = "Bucket Name for store statefile"
  default     = null
}

variable "location" {
  type        = string
  description = "Bucket Location"
  default     = null
}

variable "storage_class" {
  type        = string
  description = "Storage Class"
  default     = null
}

variable "environment" {
  type        = string
  description = "Environment Name"
  default     = null
}

variable "artifact_bucket_name" {
  type        = string
  description = "Artifact repo bucket"
}

# variable "iam_state_bucket_name" {
#   type = string 
#   description = "IAM State Bucket"
# }

variable "networking_state_bucket" {
  type = string 
  description = "Networking State bucket"
}

# Platform Terraform Bucket State
variable "platform_terraform_state" {
  type = string 
  description = "Platform terraform state"
}

variable "velero_backup_bucket_name" {
  type = string 
  description = "Velero terraform state"
}

# Loki Bucket name
variable "loki_bucket_name" {
  description = "GCS bucket used by Loki"
  type        = string
}

variable "project_id" {
  type = string 
  description = "Project ID"
}