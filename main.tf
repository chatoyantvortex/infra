module "docker_apps" {
  source = "./modules/docker-app"
  apps   = var.apps
}
