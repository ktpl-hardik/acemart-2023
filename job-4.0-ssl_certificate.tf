resource "aws_acm_certificate" "singledomain_cert" {
  domain_name       = "*.krishtechnolabs.net"
  validation_method = "DNS"

  tags = {
    "Environmnet" = "Production"
    "Terraform"   = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

/* resource "aws_acm_certificate" "wildcard_cert" {
  domain_name       = "*.acemart.com"
  validation_method = "DNS"

  tags = {
    "Environmnet" = "Production"
    "Terraform"   = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
} */