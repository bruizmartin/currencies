output "ecr_repository_url" {
  description = "ECR repository URL where the container image must be pushed"
  value       = module.ecr.repository_url
}

output "alb_dns_name" {
  description = "Public DNS name for the application"
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.ecs_service_name
}

output "ecs_task_execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = module.iam.execution_role_arn
}

output "ecs_task_role_arn" {
  description = "ECS task role ARN"
  value       = module.iam.task_role_arn
}

output "dynamodb_table_arns" {
  description = "DynamoDB table ARNs created by this root module"
  value       = { for k, m in module.dynamodb : k => m.table_arn }
}
