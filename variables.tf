variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "il-central-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the AWS key pair for SSH access"
  type        = string
}

variable "web_server_count" {
  description = "Number of web server containers to run"
  type        = number
  default     = 2
}