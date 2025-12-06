variable "dockerhub_username" {
  description = "Docker Hub username"
  type        = string
}

variable "dockerhub_token" {
  description = "Docker Hub token"
  type        = string
  sensitive   = true
}
