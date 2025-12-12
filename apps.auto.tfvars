apps = {

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
    image = "vishnukanthmca/pythonapi:latest"
    ports = [
      {
        internal = 8080
        external = 8080
      }
    ]
  }

  pythonapi_inventory = {
    image = "vishnukanthmca/pythonapi_inventory:latest"
    ports = [
      {
        internal = 8081
        external = 8081
      }
    ]
  }

}
