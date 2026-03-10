output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for az in ["a", "b"] : aws_subnet.public[az].id]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = [for az in ["a", "b"] : aws_subnet.private[az].id]
}
