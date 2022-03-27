resource "sakuracloud_packet_filter" "nextcloud" {
  name        = "nextcloud"
  description = "Packet filtering rules for nextcloud VM"
}

resource "sakuracloud_packet_filter_rules" "nextcloud_rules" {
  packet_filter_id = sakuracloud_packet_filter.nextcloud.id

  expression {
    protocol         = "tcp"
    destination_port = "22"
  }

  expression {
    protocol         = "tcp"
    destination_port = "80"
  }

  expression {
    protocol         = "tcp"
    destination_port = "443"
  }

  expression {
    protocol = "icmp"
  }

  expression {
    protocol = "fragment"
  }

  expression {
    protocol    = "ip"
    allow       = false
    description = "Deny ALL"
  }
}