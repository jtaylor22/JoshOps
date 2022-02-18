resource "aws_instance" "jenkins_instance" {
  # ami           = data.aws_ami.jenkins_ami.id
  ami = "ami-0a3dbbf9b3e12f85d"
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.jenkins_key_pair.key_name
  user_data     = file("user-data.sh")

  network_interface {
    network_interface_id = aws_network_interface.jenkins_interface.id
    device_index         = 0
  }

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_network_interface" "jenkins_interface" {
  subnet_id       = aws_subnet.private_subnet[0].id
  security_groups = [aws_security_group.jenkins_security_group.id]

  tags = {
    Name = "jenkins_network_interface"
  }
}

resource "aws_security_group" "jenkins_security_group" {
  name        = "jenkins_sg"
  description = "Allow HTTPS connectivity to Jenkins"
  vpc_id      = aws_vpc.application_vpc.id

  tags = {
    Name = "jenkins_sg"
  }
}

resource "aws_security_group_rule" "jenkins_alb_listener_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_security_group.id
}

resource "aws_security_group_rule" "jenkins_alb_target_group_rule" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.application_vpc.cidr_block]
  security_group_id = aws_security_group.jenkins_security_group.id
}

resource "aws_security_group_rule" "bastion_instance_rule" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.allow_instance_connect.id
  security_group_id        = aws_security_group.jenkins_security_group.id
}

resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_security_group.id
}