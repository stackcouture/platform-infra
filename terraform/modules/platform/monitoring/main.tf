resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false

  values = [
    yamlencode({
      installCRDs = true

      controller = {
        replicas = 2
      }

      dashboard = {
        enabled = true
      }

      metrics = {
        enabled = true
      }
    })
  ]

  set {
    name  = "installCRDs"
    value = "true"
  }
}