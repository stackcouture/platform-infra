module "argocd" {
  source = "../../../../modules/platform/argocd"

  namespace = var.namespace
}