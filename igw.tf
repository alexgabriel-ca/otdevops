resource "aws_internet_gateway" "devops_ig" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name        = "OpenText DevOps Internet Gateway"
    Environment = var.environment
  }
  depends_on = [
    aws_subnet.devops_public_subnet
  ]
}