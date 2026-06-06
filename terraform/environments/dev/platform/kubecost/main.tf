# data "terraform_remote_state" "gke" {
#   backend = "gcs"

#   config = {
#     bucket = "stackcouture-platform-tf-state"
#     prefix = "dev/gke"
#   }
# }

module "kubecost" {
  source = "../../../../modules/platform/kubecost"

  namespace    = var.namespace
  cluster_name = data.terraform_remote_state.gke.outputs.cluster_name
  project_id   = var.project_id
}