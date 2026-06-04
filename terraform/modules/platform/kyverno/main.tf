resource "kubernetes_namespace_v1" "kyverno" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kyverno" {
  name       = "kyverno"
  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"
  version    = "3.3.7"

  namespace        = kubernetes_namespace_v1.kyverno.metadata[0].name
  create_namespace = false

  timeout = 600
  wait    = true
  atomic  = true

  values = [
    yamlencode({
      admissionController = {
        replicas = 2

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

        serviceMonitor = {
          enabled = false
        }
      }

      backgroundController = {
        replicas = 2
      }

      cleanupController = {
        replicas = 1
      }

      reportsController = {
        replicas = 1
      }

      grafana = {
        enabled = false
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.kyverno
  ]
}