module "vpc" {
  source = "./modules/vpc"

  app_name              = var.app_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr_a  = var.public_subnet_cidr_a
  public_subnet_cidr_b  = var.public_subnet_cidr_b
  private_subnet_cidr_a = var.private_subnet_cidr_a
  private_subnet_cidr_b = var.private_subnet_cidr_b
}

module "ecr" {
  source = "./modules/ecr"

  repository_name   = var.app_name
  create_repository = var.create_ecr_repository
}

module "dynamodb" {
  source   = "./modules/dynamodb"
  for_each = var.dynamodb_tables

  table_name     = each.value.table_name
  hash_key       = each.value.hash_key
  hash_key_type  = each.value.hash_key_type
  range_key      = try(each.value.range_key, null)
  range_key_type = each.value.range_key_type
}

locals {
  dynamodb_access = {
    for table_key, table in var.dynamodb_tables : table_key => {
      table_arn = module.dynamodb[table_key].table_arn
      actions   = table.actions
    }
  }
}

module "iam" {
  source = "./modules/iam"

  app_name        = var.app_name
  dynamodb_access = local.dynamodb_access
}

module "ecs" {
  source = "./modules/ecs"

  app_name              = var.app_name
  aws_region            = var.aws_region
  container_port        = var.container_port
  desired_count         = var.desired_count
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  image_uri             = "${module.ecr.repository_url}:${var.image_tag}"
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  log_retention_in_days = var.log_retention_in_days
}
