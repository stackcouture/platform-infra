resource "kubernetes_namespace" "kubecost" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kubecost" {
  name       = "kubecost"
  repository = "https://kubecost.github.io/kubecost"
  chart      = "kubecost"
  version    = "3.2.1"

  namespace        = kubernetes_namespace.kubecost.metadata[0].name
  create_namespace = false

  values = [
    yamlencode({

      global = {
        clusterId = "${var.project_id}-${var.cluster_name}"

        acknowledged = true

        cspPricingApiKey = {
          useDefaultApiKey = true
        }
      }

      serviceAccount = {
        create = true
      }

      frontend = {
        replicas = 1

        nodeSelector = {
          workload = "system"
        }
      }

      aggregator = {
        replicas = 1

        nodeSelector = {
          workload = "system"
        }

        serviceMonitor = {
          enabled = true
        }

        # Aggregator ClickHouse database
        aggregatorDbStorage = {
          storageClass   = "standard-rwo"
          storageRequest = "5Gi"
        }

        # Aggregator configuration storage
        persistentConfigsStorage = {
          storageClass   = "standard-rwo"
          storageRequest = "1Gi"
        }
      }

      forecasting = {
        enabled = true

        nodeSelector = {
          workload = "system"
        }
      }

      persistentVolume = {
        enabled      = true
        size         = "5Gi"
        storageClass = "standard-rwo"
      }

      localStore = {
        persistentVolume = {
          enabled      = true
          size         = "5Gi"
          storageClass = "standard-rwo"
        }
      }

      networkCosts = {
        enabled = true

        serviceMonitor = {
          enabled = true
        }
      }

      cloudCost = {
        enabled = true

        nodeSelector = {
          workload = "system"
        }
      }

      clusterController = {
        enabled = true

        nodeSelector = {
          workload = "system"
        }
      }

      ingress = {
        enabled = false
      }

      httpRoute = {
        enabled = false
      }

      kubecostProductConfigs = {
        clusterProfile = "dev"

        currencyCode = "USD"

        shareTenancyCosts = true

        carbonEstimates = false
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.kubecost
  ]
}