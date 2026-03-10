data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.app_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.app_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

data "aws_iam_policy_document" "ecs_task_dynamodb" {
  for_each = var.dynamodb_access

  statement {
    actions   = each.value.actions
    resources = [each.value.table_arn]
  }
}

resource "aws_iam_policy" "ecs_task_dynamodb" {
  for_each = data.aws_iam_policy_document.ecs_task_dynamodb

  name   = "${var.app_name}-${each.key}-ecs-task-dynamodb-policy"
  policy = each.value.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_dynamodb" {
  for_each = aws_iam_policy.ecs_task_dynamodb

  role       = aws_iam_role.ecs_task.name
  policy_arn = each.value.arn
}
