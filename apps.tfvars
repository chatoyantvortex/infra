apps = {
  nginx-web = {
    image = "nginx:latest"
    ports = [{ internal = 80, external = 8081 }]
    env   = []
  }

  postgres-db = {
    image = "postgres:16-alpine"
    ports = [{ internal = 5432, external = 5432 }]
    env = [
      "POSTGRES_USER=appuser",
      "POSTGRES_PASSWORD=secretpassword",
      "POSTGRES_DB=appdb"
    ]
    volume = {
      host_path      = "/opt/postgres-data"
      container_path = "/var/lib/postgresql/data"
    }
  }

  pythonapi = {
    image = "vishnukanthmca/pythonapi:latest"
    ports = [{ internal = 8000, external = 8000 }]
    env = [
      "ENV=prod",
      "DATABASE_URL=postgresql://appuser:secretpassword@postgres-db:5432/appdb"
    ]
  }

  pythonapi_inventory = {
    image = "vishnukanthmca/pythonapi_inventory:latest"
    ports = [{ internal = 8001, external = 8001 }]
    env = [
      "ENV=prod",
      "DATABASE_URL=postgresql://appuser:secretpassword@postgres-db:5432/appdb"
    ]
  }
}
