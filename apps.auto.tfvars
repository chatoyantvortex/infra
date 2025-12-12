apps = {
  nginx-web = {
    image = "vishnukanthmca/nginx-web:latest"
    port  = 8085
  }
  postgres-db = {
    image = "postgres:16"
    port  = 5432
  }
  pythonapi = {
    image = "vishnukanthmca/pythonapi:latest"
    port  = 8080
  }
  pythonapi_inventory = {
    image = "vishnukanthmca/pythonapi_inventory:latest"
    port  = 8081
  }
}
