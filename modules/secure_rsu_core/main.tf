resource "aws_cloudwatch_log_group" "rsu_logs" {
  name              = "/rsu/${var.name_prefix}"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}
