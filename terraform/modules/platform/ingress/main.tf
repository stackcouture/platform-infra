resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace        = kubernetes_namespace.ingress_nginx.metadata[0].name
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }
}