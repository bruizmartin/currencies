# Infrastructure (Terraform)

This directory contains the root Terraform module for the `currencies` AWS infrastructure.

## File Structure

- `main.tf`: Root module composition (`vpc`, `ecr`, `iam`, `ecs`).
- `versions.tf`: Terraform and provider requirements.
- `variables.tf`: Input variables.
- `outputs.tf`: Output values.
- `terraform.tfvars.example`: Example variable values.
- `modules/vpc`: VPC, subnets, NAT, route tables.
- `modules/ecr`: ECR repository resolver (create or lookup).
- `modules/iam`: ECS task execution role + app task role (DynamoDB permissions).
- `modules/dynamodb`: DynamoDB table resources.
- `modules/ecs`: ALB, security groups, CloudWatch logs, ECS cluster/task/service.

Terraform loads all `*.tf` files in this directory as a single module. Filenames are for organization only.

## Current Networking Model

- Public ALB in public subnets.
- ECS tasks run in private subnets with `assign_public_ip = false`.
- Private subnet outbound internet path is through a NAT gateway in a public subnet.
- Public subnet outbound internet path is through the VPC internet gateway.

## AWS Authentication

Before running Terraform commands, authenticate with AWS and verify the active identity.

If you use long-lived access keys:

```bash
aws configure
```

If you use AWS SSO:

```bash
aws sso login --profile <aws-profile>
```

Optional: set a profile for the current shell session:

```bash
export AWS_PROFILE=<aws-profile>
```

Verify authentication:

```bash
aws sts get-caller-identity
```

## Usage

From this directory:

```bash
terraform init
terraform plan
terraform apply
```

To create an ECR repository from Terraform:

```bash
terraform plan -var create_ecr_repository=true
```

## Building and uploading the Docker image

1. Get the repository URL from Terraform output:
   ```bash
   terraform output -raw ecr_repository_url
   ```

2. Authenticate Docker against ECR:
   ```bash
   REPO_URL=$(terraform output -raw ecr_repository_url)
   aws ecr get-login-password --region eu-central-1 \
     | docker login --username AWS --password-stdin "${REPO_URL%/*}"
   ```

3. Build and push the image for `linux/amd64` (replace the tag with your release version):
   ```bash
   REPO_URL=$(terraform output -raw ecr_repository_url)
   docker buildx build --platform linux/amd64 \
     --tag "${REPO_URL}:0.0.2-SNAPSHOT" \
     --push \
     .
   ```

> **Note:** Whenever a new image tag is pushed you must update `var.image_tag` (e.g., in `terraform.tfvars` or your CI variables) and run `terraform apply` again so the ECS automatically starts a new deployment for that tag version.

## DynamoDB Tables And Task Role Access

To create tables with Terraform and grant ECS task access per table, set `dynamodb_tables`:

```hcl
dynamodb_tables = {
  currencies = {
    table_name = "currencies"
    hash_key   = "id"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:PutItem"
    ]
  }
  exchange_rates = {
    table_name = "exchange-rates"
    hash_key   = "base_currency"
    range_key  = "target_currency"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query"
    ]
  }
}
```
