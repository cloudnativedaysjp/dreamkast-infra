resource "sakuracloud_disk" "nc_sandbox_boot" {
  name              = "nc-sandbox-boot"
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

resource "sakuracloud_server" "nc_sandbox" {
  name = "nc-sandbox"
  disks = [
    sakuracloud_disk.nc_sandbox_boot.id,
  ]
  core        = 2
  memory      = 4
  description = "Nextcloud Sandbox"
  tags        = ["app=nextcloud", "stage=staging"]

  network_interface {
    upstream = "shared"
    packet_filter_id = sakuracloud_packet_filter.nextcloud.id
  }

  user_data = templatefile("./template/cloud-init.yaml", {
    vm_password = random_password.password.result,
    hostname    = "nc-sandbox"
  })

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}

