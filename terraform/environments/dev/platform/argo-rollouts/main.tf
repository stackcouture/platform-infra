module "argo_rollouts" {
  source = "../../../../modules/platform/argo-rollouts"

  namespace = var.namespace
}