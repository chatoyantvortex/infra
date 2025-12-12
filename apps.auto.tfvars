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
        internal = 8000 # Uvicorn port inside container
        external = 8080 # Public port on the server
      }
    ]
  }

  pythonapi_inventory = {
    image = "vishnukanthmca/pythonapi_inventory:latest"
    ports = [
      {
        internal = 8001 # Uvicorn port inside container
        external = 8081 # Public port on the server
      }
    ]
  }

}
