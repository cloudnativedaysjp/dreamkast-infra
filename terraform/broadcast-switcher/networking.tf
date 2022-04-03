resource "sakuracloud_switch" "switcher" {
  name        = "switcher"
  description = "switcher"
  tags        = ["switcher", "production"]
}
resource "sakuracloud_internet" "global" {
  name = "global"

  netmask     = 28
  band_width  = 250
  enable_ipv6 = false

  description = "global"
  tags        = ["global", "production"]
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
    protocol    = "tcp"
    destination_port = "3389"
  }

  expression {
    protocol    = "udp"
    destination_port = "10000-11000"
  }

  expression {
    protocol    = "tcp"
    destination_port = "10000-11000"
  }

  expression {
    protocol    = "udp"
    destination_port = "5900"
  }
  
  expression {
    protocol         = "udp"
    destination_port = "68"
  }

  expression {
    protocol = "icmp"
  }

  expression {
    protocol = "fragment"
  }

  expression {
    protocol    = "udp"
    source_port = "123"
  }

  expression {
    protocol         = "tcp"
    destination_port = "32768-61000"
  }

  expression {
    protocol         = "udp"
    destination_port = "32768-61000"
  }

  expression {
    protocol    = "ip"
    allow       = false
    description = "Deny ALL"
  }
}