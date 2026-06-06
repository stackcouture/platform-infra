module "cert_manager" {
  source = "../../../../modules/platform/cert-manager"

  namespace = var.namespace
}