variable "project_id" {
  type        = string
  description = "Project ID"
  default     = "project-18ee516c-a108-431d-a73"
}

variable "region_name" {
  type        = string
  description = "Region name"
}

# Cloud Storage Buckets
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

# IAM state bucket 
variable "iam_state_bucket_name" {
  type        = string
  description = "IAM State Bucket"
}

# Networking state bucket 
variable "networking_state_bucket" {
  type        = string
  description = "Networking State bucket"
}