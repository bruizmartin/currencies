resource "aws_ecr_repository" "this" {
  count = var.create_repository ? 1 : 0

  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_repository" "this" {
  count = var.create_repository ? 0 : 1

  name = var.repository_name
}

locals {
  repository_url  = var.create_repository ? aws_ecr_repository.this[0].repository_url : data.aws_ecr_repository.this[0].repository_url
  repository_arn  = var.create_repository ? aws_ecr_repository.this[0].arn : data.aws_ecr_repository.this[0].arn
  repository_name = var.create_repository ? aws_ecr_repository.this[0].name : data.aws_ecr_repository.this[0].name
}
