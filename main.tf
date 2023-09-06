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

#vpc creation
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Terraform and Jenkins VPC"
  cidr = "172.16.0.0/16"

  azs             = ["ca-central-1a"]
  private_subnets = ["172.16.1.0/24"]
  public_subnets  = ["172.16.101.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "Terraform and Jenkins Web Server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.10.0.0/16"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_route53_zone" "example" {
  name = "bell.ca"
}

resource "aws_route53_record" "example" {
  allow_overwrite = true
  name            = "bell.ca"
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.example.zone_id

  records = [
    aws_route53_zone.example.name_servers[0],
    aws_route53_zone.example.name_servers[1],
    aws_route53_zone.example.name_servers[2],
    aws_route53_zone.example.name_servers[3],
  ]
}
