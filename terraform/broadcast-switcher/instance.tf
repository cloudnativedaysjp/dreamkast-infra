data "sakuracloud_archive" "ubuntu" {
  filter {
    id = "113301413483"
  }
}

locals {
  switchers = [
    {
      hostname = "switcher01"
    }
  ]
}

resource "sakuracloud_disk" "switcher_boot" {
  for_each          = { for i in local.switchers : i.hostname => i }
  name              = "${each.value.hostname}-boot"
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

resource "sakuracloud_server" "switcher" {
  for_each = { for i in local.switchers : i.hostname => i }
  name     = each.value.hostname
  disks = [
    sakuracloud_disk.switcher_boot[each.key].id
  ]
  core        = 4
  memory      = 56
  gpu         = 1
  description = "Switcher server"
  tags        = ["app=switcher", "stage=production"]

  network_interface {
    upstream = "shared"
  }
  
  network_interface {
    upstream    = sakuracloud_switch.switcher.id
  }

  user_data = templatefile("./template/cloud-init.yaml", {
    vm_password = var.vm_password,
    vnc_password = var.vnc_password,
    hostname    = each.value.hostname
  })

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}
