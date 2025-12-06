terraform {
  required_version = ">= 1.5.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Kubernetes provider (k3s will write kubeconfig to /etc/rancher/k3s/k3s.yaml)
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Docker provider talks to local Docker socket
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
