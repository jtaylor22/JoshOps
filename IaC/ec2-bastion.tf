resource "aws_instance" "bastion_instance" {
  ami           = "ami-0dd555eb7eb3b7c82"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.jenkins_interface.id
    device_index         = 0
  }

  tags = {
    Name = "bastion_host"
  }
}

resource "aws_network_interface" "bastion_interface" {
  subnet_id       = aws_subnet.public_subnet[0].id
  security_groups = [aws_security_group.allow_instance_connect.id]

  tags = {
    Name = "bastion_network_interface"
  }
}

resource "aws_eip" "elastic_ip" {
  depends_on = [aws_internet_gateway.internet_gateway]
  count      = length(data.aws_availability_zones.available.names)
  vpc        = true

  tags = {
    Name = "EIP_${count.index}"
  }
}

resource "aws_eip" "bastion_eip" {
  depends_on = [aws_internet_gateway.internet_gateway]
  vpc        = true

  tags = {
    Name = "bastion_eip"
  }
}

resource "aws_eip_association" "bastion_eip_assoc" {
  instance_id          = aws_instance.bastion_instance.id
  allocation_id        = aws_eip.bastion_eip.id
  network_interface_id = aws_network_interface.bastion_interface.id
}

resource "aws_security_group" "allow_instance_connect" {
  name        = "allow_instance_connect"
  description = "Allow connectivity to AWS Instance Connect"
  vpc_id      = aws_vpc.application_vpc.id

  ingress {
    description = "SSH from EC2_INSTANCE_CONNECT service in eu-west-2 "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["3.8.37.24/29"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_instance_connect_sg"
  }
}
