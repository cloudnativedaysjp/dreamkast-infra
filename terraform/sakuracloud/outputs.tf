output "vm_password" {
  value     = random_password.password.result
  sensitive = true
}

output "vm_ip" {
  value = sakuracloud_server.nextcloud.ip_address
}