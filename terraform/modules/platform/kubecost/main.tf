resource "kubernetes_namespace" "kubecost" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kubecost" {
  name       = "kubecost"
  repository = "https://kubecost.github.io/cost-analyzer/"
  chart      = "cost-analyzer"
  version = "2.8.5"

  namespace        = kubernetes_namespace.kubecost.metadata[0].name
  create_namespace = false

  values = [
    yamlencode({
      global = {
        clusterId = "${var.project_id}-${var.cluster_name}"
      }

      kubecostProductConfigs = {
        clusterName = var.cluster_name
      }

      prometheus = {
        server = {
          enabled = false
        }

        fqdn = "http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local"
      }

      serviceAccount = {
        create = true
        name   = "kubecost"
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.kubecost
  ]
}

resource "kubernetes_service_account" "kubecost" {
  metadata {
    name      = "kubecost"
    namespace = kubernetes_namespace.kubecost.metadata[0].name

    annotations = {
      "iam.gke.io/gcp-service-account" = var.kubecost_gsa_email
    }
  }
}