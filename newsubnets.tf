provider "aws" {
  region = "us-east-1"
}
## Create Subnets ##
resource "aws_subnet" "subnet_dev1" {
  vpc_id     = "vpc-0f336485d30a2f3bc"
  cidr_block = "10.0.1.0/24"
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
  vpc_id     = "vpc-0f336485d30a2f3bc"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet_prod1"
  }
}

output "aws_subnet_subnet_prod1" {
  value = "${aws_subnet.subnet_prod1.id}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "2.70.0"
    }
  }

  backend "s3" {
    bucket = "terraform1-state-bucket"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
