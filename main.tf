module "docker_apps" {
  source = "./modules/docker-app"

  apps = var.apps

  providers = {
    docker = docker
  }
}

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

