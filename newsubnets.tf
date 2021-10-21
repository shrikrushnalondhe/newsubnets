provider "aws" {
  region = "us-east-1"
}
## Create Subnets ##
resource "aws_subnet" "subnet_dev1" {
  vpc_id     = "vpc-0c8a47d4fabd75584"
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet_dev1"
  }
}
output "aws_subnet_subnet_dev1" {
  value = "${aws_subnet.subnet_dev1.id}"
}

resource "aws_subnet" "subnet_prod1" {
  vpc_id     = "vpc-0c8a47d4fabd75584"
  cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet_prod1"
  }
}

output "aws_subnet_subnet_prod1" {
  value = "${aws_subnet.subnet_prod1.id}"
}
