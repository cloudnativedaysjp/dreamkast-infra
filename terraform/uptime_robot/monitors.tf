# Create a monitor
resource "uptimerobot_monitor" "dreamkast" {
  friendly_name = "Dreamkast"
  type          = "http"
  url           = "https://event.cloudnativedays.jp"

  alert_contact {
    id = uptimerobot_alert_contact.slack.id
  }

  alert_contact {
    id = data.uptimerobot_alert_contact.default_alert_contact.id
  }

  interval = 60

  lifecycle {
    ignore_changes = [
      alert_contact
    ]
  }
}

moved {
  from = uptimerobot_monitor.dreamkast-by-terraform
  to   = uptimerobot_monitor.dreamkast
}

resource "uptimerobot_monitor" "website" {
  friendly_name = "Website"
  type          = "http"
  url           = "https://cloudnativedays.jp"

  alert_contact {
    id = uptimerobot_alert_contact.slack.id
  }

  alert_contact {
    id = data.uptimerobot_alert_contact.default_alert_contact.id
  }

  interval = 60

  lifecycle {
    ignore_changes = [
      alert_contact
    ]
  }
}

moved {
  from = uptimerobot_monitor.website-by-terraform
  to   = uptimerobot_monitor.website
}

resource "uptimerobot_monitor" "grafana" {
  friendly_name = "Grafana"
  type          = "http"
  url           = "https://grafana.cloudnativedays.jp"

  alert_contact {
    id = uptimerobot_alert_contact.slack.id
  }

  alert_contact {
    id = data.uptimerobot_alert_contact.default_alert_contact.id
  }

  interval = 60

  lifecycle {
    ignore_changes = [
      alert_contact
    ]
  }
}

resource "uptimerobot_monitor" "nextcloud" {
  friendly_name = "Nextcloud"
  type          = "http"
  url           = "https://nextcloud.cloudnativedays.jp"

  alert_contact {
    id = uptimerobot_alert_contact.slack.id
  }

  alert_contact {
    id = data.uptimerobot_alert_contact.default_alert_contact.id
  }

  interval = 60

  lifecycle {
    ignore_changes = [
      alert_contact
    ]
  }
}

resource "uptimerobot_monitor" "prometheus" {
  friendly_name = "Prometheus"
  type          = "http"
  url           = "https://prometheus.cloudnativedays.jp/-/healthy"
  http_auth_type = "basic"
  http_username = "prometheus"
  http_password = var.prometheus_password

  alert_contact {
    id = uptimerobot_alert_contact.slack.id
  }

  alert_contact {
    id = data.uptimerobot_alert_contact.default_alert_contact.id
  }

  interval = 60

  lifecycle {
    ignore_changes = [
      alert_contact
    ]
  }
}
