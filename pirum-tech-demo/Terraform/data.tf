data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "joshdevops_hosted_zone" {
  zone_id = "Z03554172FHQ1O0A0I33R"
}

data "aws_ami" "aws_ecs_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_key_pair" "jenkins_key_pair" {
  key_name = "jenkins-private-test"
}

data "aws_route53_zone" "joshdevops_hosted_zone" {
  zone_id = "Z03554172FHQ1O0A0I33R"
}