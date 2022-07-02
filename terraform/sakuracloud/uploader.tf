resource "sakuracloud_disk" "uploader_boot" {
  name              = "uploader-boot"
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

resource "sakuracloud_server" "uploader" {
  name = "uploader"
  disks = [
    sakuracloud_disk.uploader_boot.id,
  ]
  core        = 2
  memory      = 4
  description = "Nextcloud Sandbox"
  tags        = ["app=uploader", "stage=production"]

  network_interface {
    upstream = "shared"
    packet_filter_id = sakuracloud_packet_filter.nextcloud.id
  }

  user_data = templatefile("./template/cloud-init.yaml", {
    vm_password = random_password.password.result,
    hostname    = "uploader"
  })

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}
