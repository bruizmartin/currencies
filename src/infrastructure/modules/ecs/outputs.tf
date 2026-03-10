output "alb_dns_name" {
  description = "Public DNS name for the application"
  value       = aws_lb.app.dns_name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.app.name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.app.name
}

output "target_group_arn" {
  description = "ALB target group ARN"
  value       = aws_lb_target_group.app.arn
}
