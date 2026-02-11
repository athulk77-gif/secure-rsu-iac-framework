resource "aws_lambda_function" "rsu_processor" {
  function_name = "${local.name_prefix}-rsu-processor"

  runtime = "python3.11"
  handler = "handler.main"
  role    = aws_iam_role.rsu_lambda_role.arn

  filename         = "lambda/lambda.zip"
  source_code_hash = filebase64sha256("lambda/lambda.zip")

  timeout = 10

  # ✅ Concurrency guardrail
  # reserved_concurrent_executions = 5 (doesn't work account’s total concurrency (for new accounts / credits accounts) is often:10)

  # ✅ X-Ray tracing enabled
  tracing_config {
    mode = "Active"
  }

  # ✅ Environment variable encryption using customer-managed KMS
  kms_key_arn = aws_kms_key.rsu_key.arn

  # ✅ Dead Letter Queue configuration
  dead_letter_config {
    target_arn = aws_sqs_queue.lambda_dlq.arn
  }

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.rsu_state.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_permission" "allow_iot" {
  statement_id  = "AllowIoTInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rsu_processor.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.telemetry_rule.arn
}
