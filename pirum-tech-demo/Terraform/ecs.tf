resource "aws_ecs_cluster" "pirum_tech_demo_cluster" {
  name = "pirum-tech-demo-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "pirum_tech_demo_task_definition" {
  family                   = "pirum_tech_demo_service"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([
    {
      name      = "pirum_tech_demo_service"
      image     = "734522818672.dkr.ecr.eu-west-2.amazonaws.com/test-ecr:pirum-tech-demo-image-2022-02-24-23-39-44"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-2a, eu-west-2b]"
  }
}

resource "aws_ecs_service" "pirum_tech_demo_service" {
  name            = "pirum-tech-demo-service"
  cluster         = aws_ecs_cluster.pirum_tech_demo_cluster.id
  task_definition = aws_ecs_task_definition.pirum_tech_demo_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = [for subnet in aws_subnet.private_subnet : subnet.id]
    security_groups = [aws_security_group.pirum_alb_security_group.id]
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pirum_ecs_target_group.arn
    container_name   = "pirum_tech_demo_service"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-2a, eu-west-2b]"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}