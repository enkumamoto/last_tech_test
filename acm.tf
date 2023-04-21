resource "tls_private_key" "devops-test-tls-private-key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "devops-test-self-sign-cert" {
  private_key_pem = tls_private_key.devops-test-tls-private-key.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "devops-test-self-sign-acm" {
  private_key      = tls_private_key.devops-test-tls-private-key.private_key_pem
  certificate_body = tls_self_signed_cert.devops-test-self-sign-cert.cert_pem
}
