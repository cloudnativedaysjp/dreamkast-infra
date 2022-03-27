data "aws_route53_zone" "cloudnativedays" {
  name         = "cloudnativedays.jp."
  private_zone = false
}

resource "aws_route53_record" "switcher" {
  for_each = { for i in local.switchers : i.hostname => i }
  zone_id  = data.aws_route53_zone.cloudnativedays.zone_id
  name     = "${each.key}.cloudnativedays.jp"
  type     = "A"
  ttl      = "300"
  records  = [sakuracloud_server.switcher[each.key].ip_address]
}
