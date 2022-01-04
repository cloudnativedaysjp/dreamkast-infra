module roles {
  source = "./modules/auth0_roles"

  for_each = var.auth0_roles
  name = each.key
  description = each.value
}