module "kyverno" {
  source = "../../../../modules/platform/kyverno"

  namespace = var.namespace
}