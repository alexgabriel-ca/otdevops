resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name        = "OpenText DevOps Internet Gateway"
    Environment = var.environment
  }
}