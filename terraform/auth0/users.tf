module "users" { 
  source = "./modules/auth0_users"

  for_each = { for i in var.auth0_users : i => i }
  email = each.key
  role_name_to_role_id = local.role_name_to_role_id
  members_of_roles = var.members_of_roles
}