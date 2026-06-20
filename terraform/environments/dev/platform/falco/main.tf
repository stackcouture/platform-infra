module "falco" {
  source = "../../../../modules/platform/falco"

  namespace = var.namespace
}