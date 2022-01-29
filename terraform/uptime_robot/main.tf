terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "kusama"
    workspaces {
      name = "uptime_robot"
    }
  }
  required_providers {
    uptimerobot = {
      source = "louy/uptimerobot"
      version = "0.5.1"
    }
  }
}

provider "uptimerobot" {
  api_key = "${var.uptimerobot_api_key}"
}

data "uptimerobot_account" "account" {}

data "uptimerobot_alert_contact" "default_alert_contact" {
  friendly_name = data.uptimerobot_account.account.email
}