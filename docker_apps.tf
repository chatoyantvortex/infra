# Nginx container
data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_image" "nginx" {
  name          = data.docker_registry_image.nginx.name
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
}

resource "docker_container" "nginx" {
  name  = "nginx-web"
  image = docker_image.nginx.name

  ports {
    internal = 80
    external = 8081
  }

  restart = "always"
}


# PostgreSQL container
data "docker_registry_image" "postgres" {
  name = "postgres:16-alpine"
}

resource "docker_image" "postgres" {
  name          = data.docker_registry_image.postgres.name
  pull_triggers = [data.docker_registry_image.postgres.sha256_digest]
}

resource "docker_container" "postgres" {
  name  = "postgres-db"
  image = docker_image.postgres.name

  env = [
    "POSTGRES_USER=appuser",
    "POSTGRES_PASSWORD=secretpassword",
    "POSTGRES_DB=appdb",
  ]

  ports {
    internal = 5432
    external = 5432
  }

  restart = "always"

  volumes {
    host_path      = "/opt/postgres-data"
    container_path = "/var/lib/postgresql/data"
  }

  # Ensure directory exists (you may create it via cloud-init or manually)
  provisioner "local-exec" {
    when    = create
    command = "sudo mkdir -p /opt/postgres-data && sudo chown 999:999 /opt/postgres-data"
  }
}

# ============================
# FastAPI backend container
# ============================

# Image pushed by the FastAPI app repo to GitHub Container Registry
data "docker_registry_image" "fastapi_backend" {
  # Convention: ghcr.io/<owner>/<repo>:latest
  name = "ghcr.io/amirtharajvellingiri5/fastapi-backend:latest"
}

resource "docker_image" "fastapi_backend" {
  name          = data.docker_registry_image.fastapi_backend.name
  pull_triggers = [data.docker_registry_image.fastapi_backend.sha256_digest]
}

resource "docker_container" "fastapi_backend" {
  name  = "fastapi-backend"
  image = docker_image.fastapi_backend.name

  # Change internal port if your app listens somewhere else
  ports {
    internal = 8000
    external = 8000
  }

  restart = "always"

  # Example envs – adjust to your real config -
  env = [
    "ENV=prod",
    "DATABASE_URL=postgresql://appuser:secretpassword@postgres-db:5432/appdb",
  ]

  # If you want it on a custom Docker network shared with nginx/postgres:
  # networks_advanced {
  #   name = "app-network"
  # }
}

