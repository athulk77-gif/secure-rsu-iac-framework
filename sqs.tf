resource "aws_sqs_queue" "lambda_dlq" {
  name = "${local.name_prefix}-lambda-dlq"

  kms_master_key_id = aws_kms_key.rsu_key.arn

  tags = local.common_tags
}
