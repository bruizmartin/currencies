variable "table_name" {
  description = "DynamoDB table name"
  type        = string
}

variable "hash_key" {
  description = "Partition key attribute name"
  type        = string
}

variable "hash_key_type" {
  description = "Partition key attribute type (S, N, B)"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Sort key attribute name"
  type        = string
  default     = null
  nullable    = true
}

variable "range_key_type" {
  description = "Sort key attribute type (S, N, B)"
  type        = string
  default     = "S"
}
