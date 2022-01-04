terraform {
  required_providers {
    auth0 = {
      source = "alexkappa/auth0"
      version = "0.25.0"
    }
  }
}

resource "auth0_user" "this" {
  connection_name = "Username-Password-Authentication"
  email = var.email
  roles = compact([for role_name, users in var.members_of_roles : contains(users, var.email) ? var.role_name_to_role_id[role_name] : null])
  lifecycle {
    ignore_changes = [
      name,
      connection_name,
      user_id,
      email_verified,
      family_name,
      given_name
    ]
  }
}

output "user_id" {
  value = auth0_user.this.id
}