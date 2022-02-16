resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0dd555eb7eb3b7c82"
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.jenkins_key_pair.key_name

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
  security_groups = [aws_security_group.allow_instance_connect.id]

  tags = {
    Name = "jenkins_network_interface"
  }
}

resource "aws_security_group" "jenkins_security_group" {
  name        = "jenkins_sg"
  description = "Allow HTTPS connectivity to Jenkins"
  vpc_id      = aws_vpc.application_vpc.id

  ingress {
    description = "443 Ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins_sg"
  }
}