provider "aws" {
  region = var.aws_region
}

data "aws_ami" "load_balancer" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "load_balancer" {
  name        = "load_balancer"
  description = "Allow all outbound traffic and inbound traffic on ports 80, 443, and 22"
  vpc_id      = "vpc-0a86b5aeb59d541df"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.load_balancer.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.load_balancer.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.load_balancer.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.load_balancer.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
