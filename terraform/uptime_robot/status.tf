resource "uptimerobot_status_page" "cnd" {
  friendly_name = "CloudNative Days Status"
  custom_domain = "status.cloudnativedays.jp"
  sort          = "a-z"
  monitors = [
    uptimerobot_monitor.dreamkast-by-terraform.id,
    uptimerobot_monitor.website-by-terraform.id,
    uptimerobot_monitor.grafana.id,
    uptimerobot_monitor.prometheus.id,
  ]
}
