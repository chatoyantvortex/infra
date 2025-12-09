resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }

  lifecycle {
    ignore_changes = [
      metadata,
      spec,
    ]
    prevent_destroy = true
  }
}
