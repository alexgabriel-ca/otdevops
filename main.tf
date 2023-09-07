terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ca-central-1"
}

resource "aws_vpc" "some_custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform VPC"
  }
}

resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ca-central-1a"

  tags = {
    Name = "Terraform Public Subnet"
  }
}

resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ca-central-1a"

  tags = {
    Name = "Terraform Private Subnet"
  }
}

resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name = "Terraform Internet Gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "Terraform Route Table"
  }
}

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "web_sg" {
  name   = "Terraform HTTP and SSH"
  vpc_id = aws_vpc.some_custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_instance" {
  ami           = "ami-0b4dc0f8083ae6a57"
  instance_type = "t2.micro"
  #key_name      = "MyKeyPair"

  subnet_id                   = aws_subnet.some_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex

  sudo yum install -y nginx1
  sudo systemctl enable nginx
  sudo systemctl start nginx
  EOF

  tags = {
    "Name" : "Kanye"
  }
}

output "ec2_global_ips" {
  value = ["${aws_instance.web_instance.*.public_ip}"]
}
