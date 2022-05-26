resource "sakuracloud_disk" "sentry_boot" {
  name              = "sentry-boot"
  source_archive_id = data.sakuracloud_archive.ubuntu.id
  plan              = "ssd"
  connector         = "virtio"
  size              = 100

  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakuracloud_server" "sentry" {
  name = "nextcloud"
  disks = [
    sakuracloud_disk.sentry_boot.id,
  ]
  core        = 2
  memory      = 4
  description = "Sentry server"
  tags        = ["app=sentry", "stage=production", "starred"]

  network_interface {
    upstream = "shared"
  }

  user_data = templatefile("./template/cloud-init.yaml", {
    vm_password  = random_password.password.result,
    hostname     = "sentry"
  })
}
