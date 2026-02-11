resource "aws_kms_key" "rsu_key" {
  description             = "RSU IaC security framework key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Allow full access to account root
      {
        Sid = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "kms:*"
        Resource = "*"
      },

      # Allow CloudWatch Logs service to use the key
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
      }

    ]
  })

  tags = local.common_tags
}

resource "aws_kms_alias" "rsu_alias" {
  name          = "alias/${local.name_prefix}-rsu"
  target_key_id = aws_kms_key.rsu_key.key_id
}
