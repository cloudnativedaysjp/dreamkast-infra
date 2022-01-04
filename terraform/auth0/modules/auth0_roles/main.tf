terraform {
  required_providers {
    auth0 = {
      source = "alexkappa/auth0"
      version = "0.25.0"
    }
  }
}

resource "auth0_role" "this" {
  name = var.name
  description = var.description
}

output "id" {
  value = auth0_role.this.id
}