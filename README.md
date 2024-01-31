# DevOps Workshop

This project is designed to show the following workflow:
1. Modify Terraform script via VS Code
2. Commit to repository
3. Run Jenkins Pipeline
4. Review Output

The following AWS resources are created via the Terraform script:
1. VPC
2. Public Subnet
3. Private Subnet
4. Internet Gateway
5. Route Table
6. Route Table Association
7. Network ACL
8. Security Group
9. Public EC2 Instance with Apache
10. Private EC2 Instance

The EC2 instance public and private IPs are output at the end of the Terraform script so that you can verify whether Apache was installed and configured correctly.

This project is a basic example of leveraging the DevOps methodology to deploy infrastructure as code (IaC).