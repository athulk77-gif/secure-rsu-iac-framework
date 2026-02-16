resource "aws_dynamodb_table" "rsu_state" {
  name         = "${local.name_prefix}-rsu-state"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "rsu_id"
  range_key = "timestamp"

  attribute {
    name = "rsu_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.rsu_key.arn
  }

  point_in_time_recovery {
    enabled = true
  }

  deletion_protection_enabled = true

  tags = local.common_tags
}
