terraform {
  required_providers {
    auth0 = {
      source = "alexkappa/auth0"
      version = "0.25.0"
    }
  }
}


resource "auth0_rule" "this" {
  name = var.name
  script = var.script
  order = var.order
  enabled = var.enabled
}