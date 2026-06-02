module "external_secrets" {
  source = "../../../../modules/platform/external-secrets"

  namespace = var.namespace
}