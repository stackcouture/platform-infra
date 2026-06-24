module "velero" {
  source    = "../../../../modules/platform/velero"
  namespace = var.namespace
}