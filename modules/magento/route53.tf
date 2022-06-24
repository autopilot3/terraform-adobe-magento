resource "aws_route53_record" "alb-external" {
  name    = var.domain_name
  records = [aws_alb.alb_external.dns_name]
  ttl     = 600
  type    = "CNAME"
  zone_id = var.route53_zone_id
}
