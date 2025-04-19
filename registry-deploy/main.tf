terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.1.2"
    }
  }

  backend "s3" {
    bucket       = "tenzin-cloud"
    key          = "terraform/registry-setup/registry-deploy.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "docker" {
  host     = "ssh://ubuntu@registry-1.local:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "docker_network" "service" {
  name = "service_network"
}

resource "docker_image" "cloudflared" {
  name = "cloudflare/cloudflared:2025.4.0"
}

resource "docker_container" "cloudflared" {
  name    = "cloudflared"
  image   = docker_image.cloudflared.image_id
  command = ["tunnel", "run", "registry-tenzin-cloud"]
  env     = ["TUNNEL_TOKEN=${var.cloudflare_tunnel_token}"]
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.service.id
  }
}

resource "docker_image" "registry" {
  name = "registry:3.0.0"
}

resource "docker_volume" "registry_data" {
  name = "registry_data"
}

resource "random_string" "registry" {
  length  = 32
  special = false
}

resource "tls_private_key" "registry" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "registry" {
  private_key_pem = tls_private_key.registry.private_key_pem

  dns_names = ["registry-1.local"]
  subject {
    common_name = "registry-1.local"
  }

  validity_period_hours = 600 * 24 * 60 // 600 days

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "local_file" "registry_certificate" {
  content         = tls_self_signed_cert.registry.cert_pem
  filename        = "${path.module}/registry.crt"
  file_permission = "0644"
}

resource "docker_container" "registry" {
  name    = "registry"
  image   = docker_image.registry.image_id
  restart = "unless-stopped"
  env     = ["OTEL_SDK_DISABLED=true", "OTEL_TRACES_EXPORTER=none"]

  upload {
    file    = "/certs/registry.crt"
    content = tls_self_signed_cert.registry.cert_pem
  }

  upload {
    file    = "/certs/registry.key"
    content = tls_private_key.registry.private_key_pem
  }

  upload {
    file    = "/etc/distribution/config.yml"
    content = <<-EOT
      version: 0.1

      proxy:
        remoteurl: "https://registry-1.docker.io"
        username: "${var.dockerhub_username}"
        password: "${var.dockerhub_token}"
        ttl: "4320h"

      log:
        level: "info"
        fields:
          service: "registry"
          environment: "homelab"

      storage:
        cache:
          blobdescriptor: inmemory
        tag:
          concurrencylimit: 5
        filesystem:
          rootdirectory: "/var/lib/registry"

      http:
        addr: ":443"

        tls:
          certificate: "/certs/registry.crt"
          key: "/certs/registry.key"

      health:
        storagedriver:
          enabled: true
          interval: 10s
          threshold: 3

    EOT
  }

  volumes {
    container_path = "/var/lib/registry"
    volume_name    = docker_volume.registry_data.name
  }

  ports {
    internal = 443
    external = 443
  }

  networks_advanced {
    name = docker_network.service.id
  }

}

