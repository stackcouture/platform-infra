resource "kubernetes_namespace_v1" "argo_rollouts" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argo_rollouts" {
  name       = "argo-rollouts"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-rollouts"
  version    = "2.40.5"

  namespace        = kubernetes_namespace_v1.argo_rollouts.metadata[0].name
  create_namespace = false

  timeout = 600
  wait    = true
  atomic  = true

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

  depends_on = [
    kubernetes_namespace_v1.argo_rollouts
  ]
}