resource "aws_iot_thing" "vehicle_sim" {
  name = "${local.name_prefix}-vehicle-sim"
}

resource "aws_iot_certificate" "vehicle_cert" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "attach_cert" {
  thing     = aws_iot_thing.vehicle_sim.name
  principal = aws_iot_certificate.vehicle_cert.arn
}

resource "aws_iot_policy" "vehicle_policy" {
  name = "${local.name_prefix}-vehicle-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = ["iot:Connect"]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = ["iot:Publish"]
        Resource = [
          "arn:aws:iot:${var.aws_region}:*:topic/vehicle/telemetry"
        ]
      },

      {
        Effect = "Deny"
        Action = ["iot:Publish"]
        Resource = [
          "arn:aws:iot:${var.aws_region}:*:topic/rsu/*"
        ]
      }
    ]
  })
}

resource "aws_iot_policy_attachment" "vehicle_attach" {
  policy = aws_iot_policy.vehicle_policy.name
  target = aws_iot_certificate.vehicle_cert.arn
}

resource "aws_iot_topic_rule" "telemetry_rule" {
  name    = "rsu_sec_telemetry_rule"
  enabled = true

  sql         = "SELECT * FROM 'vehicle/telemetry'"
  sql_version = "2016-03-23"

  lambda {
    function_arn = aws_lambda_function.rsu_processor.arn
  }
}