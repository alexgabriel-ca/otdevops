resource "aws_instance" "web_instance" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = "t2.micro"
  count                       = 2
  subnet_id                   = aws_subnet.some_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
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
    Name = "OpenText DevOps Apache-${count.index + 1}"
  }

}

resource "aws_instance" "private_instance" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t2.micro"

  subnet_i                   = aws_subnet.some_private_subnet.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "OpenText DevOps Private Instance"
  }
}