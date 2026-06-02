module "monitoring" {
  source = "../../../../modules/platform/monitoring"

  namespace = var.namespace
}