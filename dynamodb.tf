resource "aws_dynamodb_table" "rsu_state" {
  name         = "${local.name_prefix}-rsu-state"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "rsu_id"

  attribute {
    name = "rsu_id"
    type = "S"
  }

  server_side_encryption {
  enabled     = true
  kms_key_arn = aws_kms_key.rsu_key.arn
}

  point_in_time_recovery {
    enabled = true
  }

  tags = local.common_tags
}
