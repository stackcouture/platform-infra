resource "kubernetes_namespace" "velero" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "velero" {
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  version    = "12.0.3"

  namespace        = kubernetes_namespace.velero.metadata[0].name
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.velero
  ]
}