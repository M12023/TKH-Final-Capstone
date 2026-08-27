variable "aws_region" {
  description = "AWS region to deploy the infrastructure into."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet."
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type for the web server."
  type        = string
  default     = "t2.micro"
}

variable "home_ip" {
  description = "Home public IPv4 address (CIDR /32) allowed to SSH into the instance. Update this if your home IP changes."
  type        = string
  default     = "96.255.169.29/32"
}

variable "project_name" {
  description = "Name tag prefix applied to all resources."
  type        = string
  default     = "TKH-Final-Capstone"
}
