resource "sakuracloud_switch" "switcher" {
  name        = "switcher"
  description = "switcher"
  tags        = ["switcher", "production"]
}

resource "sakuracloud_packet_filter" "switcher" {
  name        = "switcher"
  description = "Packet filtering rules for switcher VM"
}

resource "sakuracloud_packet_filter_rules" "switcher_rules" {
  packet_filter_id = sakuracloud_packet_filter.switcher.id

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
    protocol    = "tcp"
    destination_port = "5900"
  }

  expression {
    protocol    = "udp"
    destination_port = "5900"
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