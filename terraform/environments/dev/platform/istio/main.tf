module "istio" {
  source = "../../../../modules/platform/istio"

  namespace = var.namespace
}