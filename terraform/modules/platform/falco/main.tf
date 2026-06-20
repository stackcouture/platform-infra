resource "kubernetes_namespace" "falco" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "falco" {
  name       = "falco"
  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"
  version    = "4.21.0"

  namespace        = kubernetes_namespace.falco.metadata[0].name
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.falco
  ]
}