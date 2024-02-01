resource "aws_subnet" "devops_public_subnet" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.zone

  tags = {
    Name        = "OpenText DevOps Public Subnet"
    Environment = var.environment
  }
  depends_on = [
    aws_vpc.devops_vpc
  ]
}

resource "aws_subnet" "devops_private_subnet" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.zone

  tags = {
    Name        = "OpenText DevOps Private Subnet"
    Environment = var.environment
  }
  depends_on = [
    aws_vpc.devops_vpc
  ]
}
