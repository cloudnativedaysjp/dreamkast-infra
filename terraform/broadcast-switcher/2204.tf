locals {
  instances22 = [
    {
      hostname = "test-22"
    }
  ]
}

data "sakuracloud_archive" "ubuntu22" {
  filter {
    id = "113400974476"
  }
}

resource "sakuracloud_disk" "instances22_boot" {
  for_each          = { for i in local.instances22 : i.hostname => i }
  name              = "${each.value.hostname}-boot"
  source_archive_id = data.sakuracloud_archive.ubuntu22.id
  plan              = "ssd"
  connector         = "virtio"
  size              = 20

  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakuracloud_server" "instances22" {
  for_each = { for i in local.instances22 : i.hostname => i }
  name     = each.value.hostname
  disks = [
    sakuracloud_disk.instances22_boot[each.key].id
  ]
  core        = 2
  memory      = 4
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

