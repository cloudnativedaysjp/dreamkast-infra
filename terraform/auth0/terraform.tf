terraform {
  required_providers {
    auth0 = {
      source = "alexkappa/auth0"
      version = "~> 0.25.0"
    }
  }
}
provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
}