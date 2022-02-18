resource "aws_instance" "splunk_instance" {
  ami           = data.aws_ami.splunk_ami.id
  instance_type = "t2.micro"
  key_name      = data.aws_key_pair.jenkins_key_pair.key_name
  user_data            = file("user_data_start_splunk.sh")

  network_interface {
    network_interface_id = aws_network_interface.splunk_interface.id
    device_index         = 0
  }

  tags = {
    Name = "Splunk"
  }
}

resource "aws_network_interface" "splunk_interface" {
  subnet_id       = aws_subnet.private_subnet[0].id
  security_groups = [aws_security_group.jenkins_security_group.id]

  tags = {
    Name = "splunk_network_interface"
  }
}