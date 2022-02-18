resource "aws_instance" "jenkins_slave_instance" {
  ami                  = data.aws_ami.jenkins_slave_ami.id
  instance_type        = "t2.micro"
  key_name             = data.aws_key_pair.jenkins_key_pair.key_name
  iam_instance_profile = aws_iam_instance_profile.jenkins_slave_instance_profile.name
  user_data            = file("user_data_install_java.sh")

  network_interface {
    network_interface_id = aws_network_interface.jenkins_slave_interface.id
    device_index         = 0
  }

  tags = {
    Name = "Jenkins-Slave"
  }
}

resource "aws_network_interface" "jenkins_slave_interface" {
  subnet_id       = aws_subnet.private_subnet[0].id
  security_groups = [aws_security_group.jenkins_security_group.id]

  tags = {
    Name = "jenkins_slave_network_interface"
  }
}
