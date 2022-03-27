resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

data "sakuracloud_archive" "ubuntu" {
  filter {
    id = "113301413483"
  }
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

resource "sakuracloud_disk" "nextcloud_backup" {
  name      = "nextcloud-backup"
  plan      = "hdd"
  connector = "virtio"
  size      = 2048

  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakuracloud_server" "nextcloud" {
  name = "nextcloud"
  disks = [
    sakuracloud_disk.nextcloud_boot.id,
    sakuracloud_disk.nextcloud_data.id,
    sakuracloud_disk.nextcloud_backup.id
  ]
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

resource "sakuracloud_disk" "nextcloud_boot2" {
  name              = "nextcloud-boot2"
  source_archive_id = data.sakuracloud_archive.ubuntu.id
  plan              = "ssd"
  connector         = "virtio"
  size              = 30

  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakuracloud_server" "nextcloud2" {
  name = "nextcloud2"
  disks = [
    sakuracloud_disk.nextcloud_boot2.id,
  ]
  core        = 2
  memory      = 4
  description = "New Nextcloud server"
  tags        = ["app=nextcloud", "stage=production"]

  network_interface {
    upstream = "shared"
  }

  user_data = templatefile("./template/cloud-init.yaml", {
    vm_password = random_password.password.result,
    hostname    = each.value.hostname
  })
}
