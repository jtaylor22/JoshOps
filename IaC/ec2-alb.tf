resource "aws_lb" "jenkins_alb" {
  name               = "jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenkins_security_group.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.jenkins_alb_log_bucket.bucket
    prefix  = "jenkins-alb"
    enabled = true
  }

  tags = {
    Name = "jenkins-alb"
  }
}