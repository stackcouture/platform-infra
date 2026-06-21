resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.31.0"

  namespace        = kubernetes_namespace.vault.metadata[0].name
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.vault
  ]
}