resource "uptimerobot_alert_contact" "slack" {
  friendly_name = "CND Alert by Terraform"
  type          = "slack"
  value         = var.slack_webhook_url
}