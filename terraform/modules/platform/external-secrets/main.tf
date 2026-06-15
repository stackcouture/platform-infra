resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"

  namespace        = kubernetes_namespace.external_secrets.metadata[0].name
  create_namespace = false

  # set {
  #   name  = "installCRDs"
  #   value = "true"
  # }
  values = [
    file("${path.module}/values.yaml")
  ]
}