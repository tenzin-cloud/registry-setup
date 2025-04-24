variable "dockerhub_username" {
  type        = string
  description = "The Docker Hub username"
}

variable "dockerhub_token" {
  type        = string
  description = "The Docker Hub token; a read-only token for pull-through cache"
  sensitive   = true
}
