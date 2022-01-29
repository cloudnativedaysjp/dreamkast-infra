resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

data "sakuracloud_archive" "ubuntu" {
  os_type = "ubuntu2004"
}

resource "sakuracloud_disk" "nextcloud_boot" {
  name              = "nextcloud-boot"
  source_archive_id = data.sakuracloud_archive.ubuntu.id
  plan              = "ssd"
  connector         = "virtio"
  size              = 20

  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakuracloud_disk" "nextcloud_data" {
  name      = "nextcloud-data"
  plan      = "ssd"
  connector = "virtio"
  size      = 2048

  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakuracloud_server" "nextcloud" {
  name        = "nextcloud"
  disks       = [sakuracloud_disk.nextcloud_boot.id, sakuracloud_disk.nextcloud_data.id]
  core        = 2
  memory      = 4
  description = "Nextcloud server"
  tags        = ["app=nextcloud", "stage=production"]

  network_interface {
    upstream = "shared"
  }

  disk_edit_parameter {
    hostname    = "nextcloud"
    password    = random_password.password.result
    ssh_key_ids = [for l in sakuracloud_ssh_key.key : l.id]
  }
}