resource "kubernetes_namespace_v1" "istio_system" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = "1.28.0"

  namespace        = kubernetes_namespace_v1.istio_system.metadata[0].name
  create_namespace = false

  wait    = true
  timeout = 600
  atomic  = true

  depends_on = [
    kubernetes_namespace_v1.istio_system
  ]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.28.0"

  namespace = kubernetes_namespace_v1.istio_system.metadata[0].name

  wait    = true
  timeout = 600
  atomic  = true

  values = [
    yamlencode({
      pilot = {
        replicaCount = 2
      }

      global = {
        proxy = {
          resources = {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }

      meshConfig = {
        accessLogFile = "/dev/stdout"
      }
    })
  ]

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_gateway" {
  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.28.0"

  namespace = kubernetes_namespace_v1.istio_system.metadata[0].name

  wait    = true
  timeout = 600
  atomic  = true

  values = [
    yamlencode({
      replicaCount = 2

      service = {
        type = "LoadBalancer"
      }
    })
  ]

  depends_on = [
    helm_release.istiod
  ]
}