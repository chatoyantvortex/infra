resource "null_resource" "install_docker" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      set -e

      echo "[docker] Checking if Docker is already installed..."
      if ! command -v docker >/dev/null 2>&1; then
        echo "[docker] Installing Docker Engine..."

        sudo apt-get update -y
        sudo apt-get install -y \
          ca-certificates \
          curl \
          gnupg \
          lsb-release

        # Add Docker’s official GPG key
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        # Set up the repository
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        sudo apt-get update -y
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # Add current user to docker group
        sudo usermod -aG docker $(whoami)

        echo "[docker] Installed. You might need to log out & log in again for group changes."
      else
        echo "[docker] Already installed, skipping"
      fi
    EOT
  }

  triggers = {
    always_run = timestamp()
  }

  depends_on = [null_resource.install_k3s]
}
