resource "kubernetes_namespace_v1" "keda" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.18.0"

  namespace        = kubernetes_namespace_v1.keda.metadata[0].name
  create_namespace = false

  timeout = 600
  wait    = true
  atomic  = true

  values = [
    yamlencode({
      crds = {
        install = true
      }

      operator = {
        replicaCount = 2
      }

      metricsServer = {
        replicaCount = 2
      }

      webhooks = {
        replicaCount = 2
      }

      prometheus = {
        metricServer = {
          enabled = true
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.keda
  ]
}