variable "aws_region" {
  description = "AWS region to deploy EC2"
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro" # ✅ Free Tier eligible
}

variable "key_name" {
  description = "Name of your existing AWS EC2 key pair"
  type        = string
}