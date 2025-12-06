resource "null_resource" "install_k3s" {
  # Always check and install if needed
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -e

      echo "[k3s] Checking if k3s is already installed..."
      if ! command -v k3s >/dev/null 2>&1; then
        echo "[k3s] Installing k3s (single-node)..."
        curl -sfL https://get.k3s.io | sh -

        echo "[k3s] Waiting for kubeconfig..."
        # k3s writes kubeconfig to /etc/rancher/k3s/k3s.yaml
        for i in {1..30}; do
          if [ -f /etc/rancher/k3s/k3s.yaml ]; then
            break
          fi
          echo "[k3s] kubeconfig not ready yet, waiting..."
          sleep 5
        done

        mkdir -p ~/.kube
        sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
        sudo chown $(id -u):$(id -g) ~/.kube/config

        # Use 127.0.0.1 instead of internal IP in kubeconfig
        sed -i 's/127.0.0.1/127.0.0.1/g' ~/.kube/config

        echo "[k3s] Installed and kubeconfig configured at ~/.kube/config"
      else
        echo "[k3s] Already installed, skipping"
      fi
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}

# Example: create a namespace in k3s to prove Terraform <-> k8s works
resource "kubernetes_namespace" "apps" {
  metadata {
    name = "apps"
  }

  depends_on = [null_resource, "install_k3s"]
}
