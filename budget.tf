resource "aws_budgets_budget" "project_budget" {
  name = "${local.name_prefix}-budget"

  budget_type  = "COST"
  limit_amount = "50"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"

    subscriber_email_addresses = [var.alert_email]
  }
}
