data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_key_pair" "jenkins_key_pair" {
  key_name = "jenkins-private-test"
}

data "aws_route53_zone" "joshdevops_hosted_zone" {
  zone_id = "Z03554172FHQ1O0A0I33R"
}

data "aws_ami" "jenkins_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["jenkins-ami*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [data.aws_caller_identity.current.account_id] # Canonical
}

data "aws_ami" "jenkins_slave_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["jenkins-slave-ami*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [data.aws_caller_identity.current.account_id] # Canonical
}

