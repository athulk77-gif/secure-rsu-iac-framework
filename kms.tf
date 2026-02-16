resource "aws_kms_key" "rsu_key" {
  description             = "RSU IaC security framework key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # 1️⃣ Root full access
      {
        Sid = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },

      # 2️⃣ Allow Lambda execution role to use the key
      {
        Sid = "AllowLambdaUsage"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.rsu_lambda_role.arn
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },

      # 3️⃣ Allow CloudWatch Logs service
      {
        Sid = "AllowCloudWatchLogs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },

      # 4️⃣ ✅ Allow DynamoDB service (Corrected with condition)
      {
        Sid = "AllowDynamoDBUsage"
        Effect = "Allow"
        Principal = {
          Service = "dynamodb.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "dynamodb.${var.aws_region}.amazonaws.com"
          }
        }
      }

    ]
  })

  tags = local.common_tags
}

resource "aws_kms_alias" "rsu_alias" {
  name          = "alias/${local.name_prefix}-rsu"
  target_key_id = aws_kms_key.rsu_key.key_id
}
