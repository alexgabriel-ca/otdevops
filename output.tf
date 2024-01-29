output "ec2_global_ips" {
  value = ["${aws_instance.devops_public_instance.*.public_ip}"]
}
