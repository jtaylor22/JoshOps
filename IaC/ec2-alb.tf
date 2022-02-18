resource "aws_lb" "jenkins_alb" {
  name               = "jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenkins_security_group.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "jenkins-alb"
  }
}

resource "aws_lb_target_group" "jenkins_target_group" {
  name     = "jenkins-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.application_vpc.id

  health_check {
    path = "/login"
  }
}

resource "aws_lb_target_group_attachment" "jenkins_target_group_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  target_id        = aws_instance.jenkins_instance.id
  port             = 8080
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-2:734522818672:certificate/11716689-b67b-4be4-a724-8a58f4d04993"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  }
}















resource "aws_lb" "splunk_alb" {
  name               = "splunk-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenkins_security_group.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "splunk-alb"
  }
}

resource "aws_lb_target_group" "splunk_target_group" {
  name     = "splunk-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.application_vpc.id

  health_check {
    path = "/en-GB/account/login"
  }
}

resource "aws_lb_target_group_attachment" "splunk_target_group_attachment" {
  target_group_arn = aws_lb_target_group.splunk_target_group.arn
  target_id        = aws_instance.splunk_instance.id
  port             = 8000
}

resource "aws_lb_listener" "splunk_front_end" {
  load_balancer_arn = aws_lb.splunk_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-2:734522818672:certificate/b20bee1f-9035-4402-9685-db58cd120f77"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.splunk_target_group.arn
  }
}