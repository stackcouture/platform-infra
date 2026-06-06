# data "terraform_remote_state" "gke" {
#   backend = "gcs"

#   config = {
#     bucket = "stackcouture-platform-tf-state"
#     prefix = "dev/gke"
#   }
# }

# data "terraform_remote_state" "iam" {
#   backend = "gcs"

#   config = {
#     bucket = "your-tf-state-bucket"
#     prefix = "dev/platform/iam"
#   }
# }

module "kubecost" {
  source = "../../../../modules/platform/kubecost"

  namespace    = var.namespace
  cluster_name = data.terraform_remote_state.gke.outputs.cluster_name
  project_id   = var.project_id
  # kubecost_gsa_email = data.terraform_remote_state.iam.outputs.kubecost_gsa_email
}