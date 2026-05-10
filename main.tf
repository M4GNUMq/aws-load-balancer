provider "aws" {
    region = "il-central-1"
}

data "aws_ami" "load_balancer" {
  most_recent = true
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}
