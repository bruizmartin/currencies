variable "app_name" {
  description = "Application name used as a resource prefix"
  type        = string
}

variable "dynamodb_access" {
  description = "Per-table DynamoDB access rules for the ECS task role"
  type = map(object({
    table_arn = string
    actions   = list(string)
  }))
  default = {}
}
