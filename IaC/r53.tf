resource "aws_route53_record" "jenkins_joshdevops_record" {
  zone_id = data.aws_route53_zone.joshdevops_hosted_zone.zone_id
  name    = "jenkins.joshdevops.co.uk"
  type    = "A"

  alias {
    name                   = aws_lb.jenkins_alb.dns_name
    zone_id                = aws_lb.jenkins_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "splunk_joshdevops_record" {
  zone_id = data.aws_route53_zone.joshdevops_hosted_zone.zone_id
  name    = "splunk.joshdevops.co.uk"
  type    = "A"

  alias {
    name                   = aws_lb.splunk_alb.dns_name
    zone_id                = aws_lb.splunk_alb.zone_id
    evaluate_target_health = true
  }
}