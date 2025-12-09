resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      metadata,
    ]
  }
}
