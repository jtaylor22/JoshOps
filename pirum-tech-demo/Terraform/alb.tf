resource "aws_lb" "pirum_ecs_alb" {
  name               = "pirum-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pirum_alb_security_group.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "pirum-ecs-alb"
  }
}

resource "aws_lb_target_group" "pirum_ecs_target_group" {
  name     = "pirum-ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.application_vpc.id

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.pirum_ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pirum_ecs_target_group.arn
  }
}

resource "aws_security_group" "pirum_alb_security_group" {
  name        = "pirum-alb-sg"
  description = "Allow HTTP connectivity to Pirum ECS Cluster"
  vpc_id      = aws_vpc.application_vpc.id

  tags = {
    Name = "pirum-alb-sg"
  }
}

resource "aws_security_group_rule" "pirum_alb_target_group_http_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pirum_alb_security_group.id
}

resource "aws_security_group_rule" "pirum_alb_target_group_egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pirum_alb_security_group.id
}