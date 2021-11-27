data "aws_route53_zone" "cloudnativedays" {
  name         = "cloudnativedays.jp."
  private_zone = false
}

resource "aws_route53_record" "nextcloud" {
  zone_id = data.aws_route53_zone.cloudnativedays.zone_id
  name    = "nextcloud.cloudnativedays.jp"
  type    = "A"
  ttl     = "300"
  records = [sakuracloud_server.nextcloud.ip_address]
}