provider "uptimerobot" {
  api_key = "${var.uptimerobot_api_key}"
}

data "uptimerobot_account" "account" {}

data "uptimerobot_alert_contact" "default_alert_contact" {
  friendly_name = data.uptimerobot_account.account.email
}