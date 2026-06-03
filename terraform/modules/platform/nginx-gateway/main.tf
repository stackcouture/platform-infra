resource "kubernetes_namespace" "nginx_gateway" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "nginx_gateway_fabric" {
  name       = "nginx-gateway-fabric"
  repository = "oci://ghcr.io/nginx/charts"
  chart      = "nginx-gateway-fabric"
  version    = "1.6.1"

  namespace        = kubernetes_namespace.nginx_gateway.metadata[0].name
  create_namespace = false

  timeout = 600
  atomic  = true
  wait    = true

  values = [
    yamlencode({
      replicaCount = 2

      service = {
        type = "LoadBalancer"
      }

      metrics = {
        enabled = true
      }

      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }

        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.nginx_gateway
  ]
}