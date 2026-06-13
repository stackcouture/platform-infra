module "keda" {
  source = "../../../../modules/platform/keda"

  namespace    = var.namespace
  cluster_name = data.terraform_remote_state.gke.outputs.cluster_name
  project_id   = var.project_id
}