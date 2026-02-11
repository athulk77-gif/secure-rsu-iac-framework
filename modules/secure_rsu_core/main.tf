resource "aws_dynamodb_table" "rsu_state" {
  name         = "${var.name_prefix}-rsu-state-secure"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "rsu_id"

  attribute {
    name = "rsu_id"
    type = "S"
  }

  # 🔐 Guardrail: encryption always ON
  server_side_encryption {
  enabled     = true
  kms_key_arn = var.kms_key_arn
}

  # 🔐 Guardrail: recovery always ON
  point_in_time_recovery {
    enabled = true
  }

  deletion_protection_enabled = true

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "rsu_logs" {
  name              = "/rsu/${var.name_prefix}"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}
