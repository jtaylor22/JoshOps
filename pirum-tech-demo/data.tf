data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "joshdevops_hosted_zone" {
  zone_id = "Z03554172FHQ1O0A0I33R"
}
