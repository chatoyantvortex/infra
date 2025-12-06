# Simple proof that Kubernetes provider works
resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }
}
