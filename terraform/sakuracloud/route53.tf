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

resource "aws_route53_record" "nextcloud2" {
  zone_id = data.aws_route53_zone.cloudnativedays.zone_id
  name    = "nextcloud2.cloudnativedays.jp"
  type    = "A"
  ttl     = "300"
  records = [sakuracloud_server.nextcloud2.ip_address]
}

resource "aws_route53_record" "sentry" {
  zone_id = data.aws_route53_zone.cloudnativedays.zone_id
  name    = "sentry.cloudnativedays.jp"
  type    = "A"
  ttl     = "300"
  records = [sakuracloud_server.sentry.ip_address]
}

resource "aws_route53_record" "nc_sandbox" {
  zone_id = data.aws_route53_zone.cloudnativedays.zone_id
  name    = "nc-sandbox.cloudnativedays.jp"
  type    = "A"
  ttl     = "300"
  records = [sakuracloud_server.nc_sandbox.ip_address]
}

resource "aws_route53_record" "uploader" {
  zone_id = data.aws_route53_zone.cloudnativedays.zone_id
  name    = "uploader.cloudnativedays.jp"
  type    = "A"
  ttl     = "300"
  records = [sakuracloud_proxylb.uploader.vip]
  depends_on = [
    sakuracloud_proxylb.uploader
  ]
}

resource "aws_route53_record" "uploader_internal" {
  zone_id = data.aws_route53_zone.cloudnativedays.zone_id
  name    = "uploader-internal.cloudnativedays.jp"
  type    = "A"
  ttl     = "300"
  records = [sakuracloud_server.uploader.ip_address]
}
