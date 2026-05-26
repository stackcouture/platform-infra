resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  uniform_bucket_level_access = true
  force_destroy = false
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Artifact Bucket 
resource "google_storage_bucket" "artifact_repo_bucket" {
  name          = var.artifact_bucket_name
  location      = var.location
  storage_class = var.storage_class
  uniform_bucket_level_access = true
  force_destroy = false
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# IAM Bucket 
resource "google_storage_bucket" "iam_state_bucket" {
  name          = var.iam_state_bucket_name
  location      = var.location
  storage_class = var.storage_class
  uniform_bucket_level_access = true
  force_destroy = false
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# IAM Bucket 
resource "google_storage_bucket" "networking_state_bucket" {
  name          = var.networking_state_bucket
  location      = var.location
  storage_class = var.storage_class
  uniform_bucket_level_access = true
  force_destroy = false
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}