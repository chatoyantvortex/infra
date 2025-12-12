variable "apps" {
  description = "Map of application definitions for container deployment."
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
