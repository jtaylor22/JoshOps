resource "aws_route53_record" "pirum_joshdevops_record" {
  zone_id = data.aws_route53_zone.joshdevops_hosted_zone.zone_id
  name    = "pirum.joshdevops.co.uk"
  type    = "A"

  alias {
    name                   = aws_lb.pirum_ecs_alb.dns_name
    zone_id                = aws_lb.pirum_ecs_alb.zone_id
    evaluate_target_health = true
  }
}