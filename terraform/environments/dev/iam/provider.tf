terraform {
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "gcs" {
    bucket = "iam-dev-state-bucket"
    prefix = "dev/iam-state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region_name
  zone    = var.zone_name
}