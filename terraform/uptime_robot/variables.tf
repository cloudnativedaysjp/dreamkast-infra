variable "uptimerobot_api_key" {
  type        = string
  description = "API key for Uptime Robot."
}

variable "slack_webhook_url" {
  type        = string
  description = "Webhook url for slack"
}

variable "prometheus_password" {
  type        = string
  description = "Basic auth password for prometheus endpoint"
}