variable "app_name" {
  description = "Application name used as a resource prefix"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
}

variable "task_memory" {
  description = "Fargate task memory in MiB"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "image_uri" {
  description = "Container image URI including tag"
  type        = string
}

variable "execution_role_arn" {
  description = "Task execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN"
  type        = string
  default     = null
  nullable    = true
}

variable "log_retention_in_days" {
  description = "CloudWatch log group retention in days"
  type        = number
  default     = 14
}
