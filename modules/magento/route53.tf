resource "aws_route53_record" "alb-varnish-public" {
  name    = var.domain_name
  records = [aws_alb.alb_varnish.dns_name]
  ttl     = 600
  type    = "CNAME"
  zone_id = var.route53_zone_id
}
