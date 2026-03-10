variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "create_repository" {
  description = "When true, creates the ECR repository. When false, looks up an existing one."
  type        = bool
  default     = false
}
