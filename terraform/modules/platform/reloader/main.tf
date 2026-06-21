resource "kubernetes_namespace_v1" "reloader" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "2.2.2"

  namespace        = kubernetes_namespace_v1.reloader.metadata[0].name
  create_namespace = false

  timeout = 600
  wait    = true
  atomic  = true

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace_v1.reloader
  ]
}