variable "aws_region" {
  description = "AWS region to deploy resources to"
  type        = string
  default     = "eu-central-1"
}

variable "app_name" {
  description = "Application name used as a resource prefix"
  type        = string
  default     = "currencies"
}

variable "container_port" {
  description = "Port exposed by the Spring Boot container"
  type        = number
  default     = 8080
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 512
}

variable "image_tag" {
  description = "Container image tag in ECR"
  type        = string
  default     = "latest"
}

variable "create_ecr_repository" {
  description = "When true, create ECR repository. When false, use existing."
  type        = bool
  default     = false
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable  "dynamodb_tables" {
  description = "DynamoDB tables managed by this stack and their task-role permissions"
  type = map(object({
    table_name     = string
    hash_key       = string
    hash_key_type  = optional(string, "S")
    range_key      = optional(string)
    range_key_type = optional(string, "S")
    actions        = list(string)
  }))
  default = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet A"
  type        = string
  default     = "10.0.101.0/24"
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet B"
  type        = string
  default     = "10.0.102.0/24"
}
