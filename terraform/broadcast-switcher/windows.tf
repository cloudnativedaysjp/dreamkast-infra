data "sakuracloud_archive" "windows" {
  filter {
    id = "113301924671"
  }
}


locals {
  windows = [
    {
      hostname = "windows01",
    }
  ]
}

resource "sakuracloud_disk" "windows_boot" {
  for_each          = { for i in local.windows : i.hostname => i }
  name              = "${each.value.hostname}-boot"
  source_archive_id = data.sakuracloud_archive.windows.id
  plan              = "ssd"
  connector         = "virtio"
  size              = 100

  lifecycle {
    ignore_changes = [
      source_archive_id,
    ]
  }
}

resource "sakuracloud_server" "windows" {
  for_each = { for i in local.windows : i.hostname => i }
  name     = each.value.hostname
  disks = [
    sakuracloud_disk.windows_boot[each.key].id
  ]
  core        = 8
  memory      = 16
  description = "Windowws insntaces"
  tags        = ["app=instance", "stage=production", "os=windows"]

  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.switcher.id
  }

  network_interface {
    upstream = sakuracloud_switch.switcher.id
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}
