locals {
  instances = [
    {
      hostname = "nginx01"
    }
  ]
}

resource "sakuracloud_disk" "instances_boot" {
  for_each          = { for i in local.instances : i.hostname => i }
  name              = "${each.value.hostname}-boot"
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

resource "sakuracloud_server" "instances" {
  for_each = { for i in local.instances : i.hostname => i }
  name     = each.value.hostname
  disks = [
    sakuracloud_disk.instances_boot[each.key].id
  ]
  core        = 8
  memory      = 16
  description = "Generic insntaces"
  tags        = ["app=instance", "stage=production"]

  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.switcher.id
  }

  network_interface {
    upstream = sakuracloud_switch.switcher.id
  }

  user_data = templatefile("./template/gui-cloud-init.yaml", {
    vm_password  = var.vm_password,
    hostname     = each.value.hostname
  })

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}
