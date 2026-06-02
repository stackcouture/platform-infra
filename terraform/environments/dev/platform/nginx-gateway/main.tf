module "nginx_gateway" {
  source = "../../../../modules/platform/nginx-gateway"

  namespace = var.namespace
}