provider "google" {
  project = var.project_id
  region  = var.region_name
}

terraform {
  backend "gcs" {
    bucket = "stackcouture-platform-tf-state"
    prefix = "dev/platform/cert-manager"
  }
}

data "google_client_config" "default" {}

data "terraform_remote_state" "gke" {
  backend = "gcs"

  config = {
    bucket = "stackcouture-platform-tf-state"
    prefix = "dev/gke"
  }
}

provider "kubernetes" {
  host = "https://${data.terraform_remote_state.gke.outputs.cluster_endpoint}"

  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.gke.outputs.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host = "https://${data.terraform_remote_state.gke.outputs.cluster_endpoint}"

    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.gke.outputs.cluster_ca_certificate
    )
  }
}