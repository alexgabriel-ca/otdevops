resource "aws_instance" "devops_public_instance" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = "t2.micro"
  count                       = var.environment == "Production" ? 2 : 1
  subnet_id                   = aws_subnet.devops_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.devops_public_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash -ex
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
  EOF

  tags = {
    Name        = "OpenText DevOps Apache-${count.index + 1}"
    Environment = var.environment
  }
  depends_on = [
    aws_security_group.devops_public_sg
  ]
}

resource "aws_instance" "devops_private_instance" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.devops_private_subnet.id
  vpc_security_group_ids      = [aws_security_group.devops_private_sg.id]
  associate_public_ip_address = false

  tags = {
    Name        = "OpenText DevOps Private Instance"
    Environment = var.environment
  }
  depends_on = [
    aws_security_group.devops_private_sg
  ]
}