terraform {
  backend "gcs" {
    bucket = "stackcouture-platform-tf-state"
    prefix = "dev/platform/falco"
  }
}