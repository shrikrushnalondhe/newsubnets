provider "aws" {
  region = "us-east-1"
}
resource "aws_internet_gateway" "default" {
    vpc_id = "vpc-0413727213c90fd60"
        tags = {
        Name = "igw-ac9731d6"
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
    vpc_id = "vpc-0413727213c90fd60"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
        Name = "DemoRT"
    }
}

resource "aws_route_table_association" "terraform-public" {
    subnet_id = "${aws_subnet.subnet_dev.id}"
    route_table_id = "rtb-07a66d41e9e544274"
}

resource "aws_security_group" "allow_all" {
  name        = "DemoSG"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-0413727213c90fd60"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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
    key_name = "aws_key"
    subnet_id = "${aws_subnet.subnet_dev.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true
    tags = {
        Name = "dev"
        Env = "dev"
        Owner = "dev"
    }
connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "jenkins"
      private_key = file("/home/jenkins/keys/aws_key")
      timeout     = "4m"
  }
}
  resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEow39dpuUvWpWbXElpfvuRa21y/01xnS1mDKPyujtNRS00IZG1+Z8vFxXwc10+lZBoEE1TuQi02KShISdCVvkUBMeFjNGr7TOoiS32dK3ixig90e1HlpoNhlXYDk+a+uzwHzLdiBM9ETBt0yuTYKiSsYY/nCc9Yy8qVjnao1E/m8KX0PNXeAw6C3VfvEqlC0OD4cUGrgGsSstd4DANdoNkJ9g7ElMsVYcyWBS6mqu11gaRMJdRcVYrAyx8ZfJwUmHujusVWLv2JfyyftjW8FtPPi0wB/c1HUnlmInEopV5y/DChovB0Uvuyp3uJaFHbQ3hTyv7re5fOEqJ038gCTT root@ip-172-31-30-210.ec2.internal"
}


resource "aws_instance" "prod" {
    #ami = "${data.aws_ami.my_ami.id}"
    ami = "ami-01cc34ab2709337aa"
    availability_zone = "us-east-1b"
    instance_type = "t2.micro"
    key_name = "aws_key"
    subnet_id = "${aws_subnet.subnet_prod.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true
    tags = {
        Name = "prod"
        Env = "prod"
        Owner = "prod"
    }
}
#output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
