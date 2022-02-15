resource "aws_vpc" "application_vpc" {
  cidr_block       = "172.31.0.0/24"

  tags = {
    Name = "Application_VPC"
  }
}

resource "aws_subnet" "main" {
    count            = length(data.aws_avaiability_zones.available.names)
    vpc_id              = aws_vpc.application_vpc.id
    cidr_block        = cidrsubnet(aws_vpc.application_vpc.cidr_block, 3, count.index)
    availability_zone   = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "public_subnet_${cound.index}"
    }
}