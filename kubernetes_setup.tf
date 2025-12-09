resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
    labels = {
      managed = "terraform"
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }
}
