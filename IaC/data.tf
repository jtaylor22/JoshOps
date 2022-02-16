data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_key_pair" "jenkins_key_pair" {
  key_name = "jenkins-private-test"
}