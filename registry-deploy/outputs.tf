output "registry_certificate" {
  value       = tls_self_signed_cert.registry.cert_pem
  description = "The self-signed certificate of the registry, for use internal to home lab network."
}
