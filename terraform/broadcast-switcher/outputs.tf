data "sakuracloud_server_vnc_info" "instances" {
  server_id = sakuracloud_server.foobar.id
}

data "sakuracloud_server_vnc_info" "switcher" {
  for_each = { for i in local.switchers : i.hostname => i }
  server_id = sakuracloud_server.switcher[each.key].id
}

data "sakuracloud_server_vnc_info" "instances" {
  for_each = { for i in local.instances : i.hostname => i }
  server_id = sakuracloud_server.instances[each.key].id
}