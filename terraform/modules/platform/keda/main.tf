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
    file("${path.module}/values.yaml")
  ]
  
  depends_on = [
    kubernetes_namespace_v1.keda
  ]
}