locals {
  instances2204 = [
    {
      hostname = "2204"
    }
  ]
}

resource "sakuracloud_disk" "instances2204_boot" {
  for_each          = { for i in local.instances2204 : i.hostname => i }
  name              = "${each.value.hostname}-boot"
  source_archive_id = data.sakuracloud_archive.ubuntu2204.id
  plan              = "ssd"
  connector         = "virtio"
  size              = 20

  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakuracloud_server" "instances2204" {
  for_each = { for i in local.instances2204 : i.hostname => i }
  name     = each.value.hostname
  disks = [
    sakuracloud_disk.instances2204_boot[each.key].id
  ]
  core        = 2
  memory      = 8
  description = "Generic insntaces"
  tags        = ["app=instance", "stage=production"]

  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.switcher.id
  }

  disk_edit_parameter {
    hostname        = each.value.hostname
    password        = var.vm_password
    disable_pw_auth = true
  }
}

resource "sakuracloud_note" "install" {
  name    = "ubuntu2204-install"
  content = file("scripts/install.sh")
}

