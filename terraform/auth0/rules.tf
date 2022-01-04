module rules {
  source = "./modules/auth0_rules"

  for_each = local.auth0_rules
  name =  each.key
  script =  each.value.script
  order =  each.value.order
  enabled =  each.value.enabled
}