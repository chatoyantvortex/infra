apps = {
  nginx-web = {
    image = "***/nginx-web:latest"
    ports = [
      {
        internal = 8085
        external = 8085
      }
    ]
  }

  postgres-db = {
    image = "postgres:16"
    ports = [
      {
        internal = 5432
        external = 5432
      }
    ]
  }

  pythonapi = {
    image = "***/pythonapi:latest"
    ports = [
      {
        internal = 8080
        external = 8080
      }
    ]
  }

  pythonapi_inventory = {
    image = "***/pythonapi_inventory:latest"
    ports = [
      {
        internal = 8081
        external = 8081
      }
    ]
  }
}
