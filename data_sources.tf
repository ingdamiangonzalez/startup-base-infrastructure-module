/*----------------------------------------------------------------------*/
/* ECS Taks Service Role                                                */
/*----------------------------------------------------------------------*/

data "aws_iam_policy_document" "ecs_tasks_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    effect = "Allow"
  }
}

/*----------------------------------------------------------------------*/
/* ECS Tasks Service Role Policy                                        */
/*----------------------------------------------------------------------*/

data "aws_iam_policy" "aws_ecs_tasks_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

/*----------------------------------------------------------------------*/
/* S3 Service Role                                                      */
/*----------------------------------------------------------------------*/

data "aws_iam_policy_document" "s3_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    effect = "Allow"
  }
}

/*----------------------------------------------------------------------*/
/* S3 Service Role Policy                                               */
/*----------------------------------------------------------------------*/

data "aws_iam_policy_document" "s3_role_policy" {
  statement {
    sid = "AllowAllOperations"

    actions = ["s3:*"]

    effect = "Allow"

    resources = ["arn:aws:s3:::${local.common_name}-*"]
  }

  statement {
    sid = "AllowIAMRoleOperations"

    actions = [
      "iam:ListRoles",
      "iam:PassRole"
    ]

    effect = "Allow"

    resources = ["*"]
  }
}
