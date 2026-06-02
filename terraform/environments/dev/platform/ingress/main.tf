module "ingress" {
  source = "../../../../modules/platform/ingress"

  namespace = var.namespace
}