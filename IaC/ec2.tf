resource "aws_vpc" "application_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Application_VPC"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    Name = "Application_IGW"
  }
}

resource "aws_route_table" "igw_route_table" {
  vpc_id = aws_vpc.application_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "IGW_route_table"
  }
}

resource "aws_route_table" "nat_gw_route_table" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.application_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "NAT_gw_route_table_${count.index}"
  }
}

resource "aws_route_table_association" "igw_route_table_association" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_route_table_association" "nat_gw_route_table_association" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.nat_gw_route_table[count.index].id
}

resource "aws_subnet" "public_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.application_vpc.cidr_block, 3, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public_subnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.application_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.application_vpc.cidr_block, 3, count.index + 3)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private_subnet_${count.index}"
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

resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.internet_gateway]
  count         = length(data.aws_availability_zones.available.names)
  allocation_id = aws_eip.elastic_ip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "NAT_gw_${count.index}"
  }
}





resource "aws_network_interface" "bastion_network_interface" {
  subnet_id = aws_subnet.public_subnet[0].id

  tags = {
    Name = "bastion_network_interface"
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
  network_interface_id = aws_network_interface.bastion_network_interface.id
}

resource "aws_instance" "bastion_instance" {
  ami           = "ami-0dd555eb7eb3b7c82"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_instance_connect.id]

  network_interface {
    network_interface_id = aws_network_interface.bastion_network_interface.id
    device_index         = 0
  }

  tags = {
    Name = "bastion_host"
  }
}

resource "aws_security_group" "allow_instance_connect" {
  name        = "allow_instance_connect"
  description = "Allow connectivity to AWS Instance Connect"
  vpc_id      = aws_vpc.application_vpc.id

  ingress {
    description      = "SSH from EC2_INSTANCE_CONNECT service in eu-west-2 "
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["3.8.37.24/29"]
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