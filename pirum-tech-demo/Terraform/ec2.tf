resource "aws_instance" "pirum_ecs_docker_instance" {
  ami           = data.aws_ami.aws_ecs_ami.id
  instance_type = "t3.large"
  iam_instance_profile = aws_iam_instance_profile.ecs_docker_instance_profile.name
  user_data     = file("user_data.sh")
  key_name      = data.aws_key_pair.jenkins_key_pair.key_name

  network_interface {
    network_interface_id = aws_network_interface.pirum_ecs_interface.id
    device_index         = 0
  }

  tags = {
    Name = "pirum-ecs-docker-instance"
  }
}

resource "aws_network_interface" "pirum_ecs_interface" {
  subnet_id       = aws_subnet.private_subnet[0].id
  security_groups = [aws_security_group.pirum_ecs_docker_instance_security_group.id]

  tags = {
    Name = "pirum-ecs-instance-eni"
  }
}

resource "aws_security_group" "pirum_ecs_docker_instance_security_group" {
  name        = "pirum-ecs-docker-sg"
  description = "Allow connectivity from ECS to EC2"
  vpc_id      = aws_vpc.application_vpc.id

  tags = {
    Name = "pirum-ecs-docker-sg"
  }
}

resource "aws_security_group_rule" "ecs_ingress_rule" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pirum_ecs_docker_instance_security_group.id
}

resource "aws_security_group_rule" "ecs_egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.pirum_ecs_docker_instance_security_group.id
}