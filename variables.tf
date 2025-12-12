variable "dockerhub_username" {
  type        = string
  description = "Docker Hub username"
}

variable "dockerhub_token" {
  type        = string
  sensitive   = true
  description = "Docker Hub token"
}

variable "apps" {
  description = "Map of application configurations"
  type = map(object({
    image = string
    ports = list(object({
      internal = number
      external = number
    }))
    env = optional(list(string), [])
    volume = optional(object({
      host_path      = string
      container_path = string
    }))
  }))
}
