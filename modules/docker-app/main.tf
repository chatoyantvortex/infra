data "docker_registry_image" "apps" {
  for_each = var.apps
  name     = each.value.image
}

resource "docker_image" "apps" {
  for_each      = var.apps
  name          = data.docker_registry_image.apps[each.key].name
  pull_triggers = [data.docker_registry_image.apps[each.key].sha256_digest]
}

resource "docker_container" "apps" {
  for_each = var.apps

  name     = each.key
  image    = docker_image.apps[each.key].name
  must_run = true
  restart  = "always"

  dynamic "ports" {
    for_each = each.value.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  env = each.value.env

  dynamic "volumes" {
    for_each = each.value.volume != null ? [each.value.volume] : []
    content {
      host_path      = volumes.value.host_path
      container_path = volumes.value.container_path
    }
  }

  lifecycle {
    replace_triggered_by = [
      docker_image.apps[each.key]
    ]
  }
}
