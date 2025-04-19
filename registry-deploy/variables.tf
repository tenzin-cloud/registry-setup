variable "cloudflare_tunnel_token" {
  type        = string
  description = "The Cloudflare tunnel token"
  sensitive   = true
}

variable "dockerhub_username" {
  type        = string
  description = "The Docker Hub username"
}

variable "dockerhub_token" {
  type        = string
  description = "The Docker Hub token"
  sensitive   = true
}
