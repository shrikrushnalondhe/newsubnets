provider "aws" {
  region = "us-east-1"
}
resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
	tags = {
        Name = "${var.IGW_demo}"
    }
}

## Create Subnets ##
resource "aws_subnet" "subnet_dev" {
  vpc_id     = "vpc-0413727213c90fd60"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet_dev"
  }
}
output "aws_subnet_subnet_dev" {
  value = "${aws_subnet.subnet_dev.id}"
}

resource "aws_subnet" "subnet_prod" {
  vpc_id     = "vpc-0413727213c90fd60"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet_prod"
  }
}

output "aws_subnet_subnet_prod" {
  value = "${aws_subnet.subnet_prod.id}"
}

resource "aws_route_table" "terraform-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

resource "aws_route_table_association" "terraform-public" {
    subnet_id = "${aws_subnet.subnet_dev.id}"
    route_table_id = "${aws_route_table.terraform-public.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

#data "aws_ami" "my_ami" {
#      most_recent      = true
#      #name_regex       = "^mavrick"
#      owners           = ["885270470374"]
#}


resource "aws_instance" "dev" {
    #ami = "${data.aws_ami.my_ami.id}"
    ami = "ami-01cc34ab2709337aa"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "awsKey"
    subnet_id = "${aws_subnet.subnet_dev.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    tags = {
        Name = "dev"
        Env = "dev"
        Owner = "dev"
    }
}

#output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
