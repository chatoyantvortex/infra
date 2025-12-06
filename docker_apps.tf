# Re-use docker provider and make sure Docker is installed first
data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_image" "nginx" {
  name          = data.docker_registry_image.nginx.name
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]

  depends_on = [null_resource.install_docker]
}

resource "docker_container" "nginx" {
  name  = "nginx-web"
  image = docker_image.nginx.name

  ports {
    internal = 80
    external = 8081
  }

  restart = "always"

  depends_on = [docker_image.nginx]
}

# Example: PostgreSQL container
data "docker_registry_image" "postgres" {
  name = "postgres:16-alpine"
}

resource "docker_image" "postgres" {
  name          = data.docker_registry_image.postgres.name
  pull_triggers = [data.docker_registry_image.postgres.sha256_digest]

  depends_on = [null_resource.install_docker]
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

  # Optional: persist data
  volumes {
    host_path      = "/opt/postgres-data"
    container_path = "/var/lib/postgresql/data"
  }

  depends_on = [docker_image.postgres]
}
