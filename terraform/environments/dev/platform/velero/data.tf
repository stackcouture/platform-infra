data "google_client_config" "default" {}

data "terraform_remote_state" "gke" {
  backend = "gcs"

  config = {
    bucket = "stackcouture-platform-tf-state"
    prefix = "dev/gke"
  }
}