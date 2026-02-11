resource "aws_lambda_function" "rsu_processor" {
  function_name = "${local.name_prefix}-rsu-processor"

  runtime = "python3.11"
  handler = "handler.main"
  role    = aws_iam_role.rsu_lambda_role.arn

  filename         = "lambda/lambda.zip"
  source_code_hash = filebase64sha256("lambda/lambda.zip")

  timeout = 10

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
}
