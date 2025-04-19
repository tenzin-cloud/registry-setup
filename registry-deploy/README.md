# README
A Terraform configuration workspace to deploy a Docker Hub pull-through cache for my home lab.  See helpful docs here: <https://distribution.github.io/distribution/about/deploying/>.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 3.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_docker"></a> [docker](#provider\_docker) | 3.1.2 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Resources

| Name | Type |
|------|------|
| [docker_container.cloudflared](https://registry.terraform.io/providers/kreuzwerker/docker/3.1.2/docs/resources/container) | resource |
| [docker_container.registry](https://registry.terraform.io/providers/kreuzwerker/docker/3.1.2/docs/resources/container) | resource |
| [docker_image.cloudflared](https://registry.terraform.io/providers/kreuzwerker/docker/3.1.2/docs/resources/image) | resource |
| [docker_image.registry](https://registry.terraform.io/providers/kreuzwerker/docker/3.1.2/docs/resources/image) | resource |
| [docker_network.service](https://registry.terraform.io/providers/kreuzwerker/docker/3.1.2/docs/resources/network) | resource |
| [docker_volume.registry_data](https://registry.terraform.io/providers/kreuzwerker/docker/3.1.2/docs/resources/volume) | resource |
| [local_file.registry_certificate](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_string.registry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.registry](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.registry](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare_tunnel_token"></a> [cloudflare\_tunnel\_token](#input\_cloudflare\_tunnel\_token) | The Cloudflare tunnel token | `string` | n/a | yes |
| <a name="input_dockerhub_token"></a> [dockerhub\_token](#input\_dockerhub\_token) | The Docker Hub token | `string` | n/a | yes |
| <a name="input_dockerhub_username"></a> [dockerhub\_username](#input\_dockerhub\_username) | The Docker Hub username | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registry_certificate"></a> [registry\_certificate](#output\_registry\_certificate) | The self-signed certificate of the registry, for use internal to home lab network. |
<!-- END_TF_DOCS -->
