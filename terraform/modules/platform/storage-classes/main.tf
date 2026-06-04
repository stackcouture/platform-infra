resource "kubernetes_storage_class" "premium_rwo_v2" {
  metadata {
    name = "premium-rwo-v2"
  }

  storage_provisioner = "pd.csi.storage.gke.io"

  parameters = {
    type = "pd-balanced"
  }

  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  allow_volume_expansion = true
}