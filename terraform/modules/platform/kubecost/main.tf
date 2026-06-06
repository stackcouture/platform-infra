resource "kubernetes_namespace" "kubecost" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kubecost" {
  name       = "kubecost"
  repository = "https://kubecost.github.io/cost-analyzer/"
  chart      = "cost-analyzer"
  version    = "2.8.5"

  namespace        = kubernetes_namespace.kubecost.metadata[0].name
  create_namespace = false

  values = [
    yamlencode({
      global = {
        clusterId = "${var.project_id}-${var.cluster_name}"

        prometheus = {
          enabled = false
          fqdn    = "http://kube-prometheus-stack-prometheus.monitoring.svc.cluster.local:9090"
        }
      }

      kubecostProductConfigs = {
        clusterName = var.cluster_name
      }

      persistentVolume = {
        enabled = false
      }

      serviceAccount = {
        create = true
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.kubecost
  ]
}