provider "aws" {
  region = var.aws_region
}

data "aws_ami" "load_balancer" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0a86b5aeb59d541df"]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
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

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  instance_type               = var.instance_type
  key_name                    = var.key_name
  name                        = "load-balancer"
  ami                         = data.aws_ami.load_balancer.id
  subnet_id                   = data.aws_subnets.public.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.load_balancer.id]
  user_data = templatefile("${path.module}/initLB.sh", {
    web_server_count = var.web_server_count
  })

  tags = {
    Terraform = "true"
  }
}
