variable "app_name" {
  description = "Application name used as a resource prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet A"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet B"
  type        = string
}
