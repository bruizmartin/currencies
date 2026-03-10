# Infrastructure (Terraform)

This directory contains the root Terraform module for the `currencies` AWS infrastructure.

## File Structure

- `versions.tf`: Terraform and provider requirements.
- `variables.tf`: Input variables.
- `locals.tf`: Shared local values used across this module.
- `network.tf`: VPC, subnets, internet gateway, route table, associations.
- `security.tf`: Security groups for ALB and ECS service.
- `load-balancing.tf`: Application Load Balancer, target group, listener.
- `iam.tf`: ECS task execution IAM role and policy attachment.
- `compute.tf`: ECS cluster, task definition, ECS service.
- `observability.tf`: CloudWatch log group.
- `ecr.tf`: ECR repository.
- `outputs.tf`: Output values.
- `terraform.tfvars.example`: Example variable values.

Terraform loads all `*.tf` files in this directory as a single module. Filenames are for organization only.

## Current Networking Model

- Public ALB in public subnets.
- ECS tasks also run in public subnets with `assign_public_ip = true`.
- Outbound internet path is through the VPC internet gateway.

If moving ECS tasks to private subnets, add NAT or required VPC endpoints (for example ECR, CloudWatch Logs, S3).

## Usage

From this directory:

```bash
terraform init
terraform plan
terraform apply
```

Or from repo root:

```bash
terraform -chdir=src/infrastructure init
terraform -chdir=src/infrastructure plan
terraform -chdir=src/infrastructure apply
```

## Notes

- Keep strongly coupled resources in the same file (for example ALB + listener + target group).
- Introduce submodules only when logic is reused across services/environments.
