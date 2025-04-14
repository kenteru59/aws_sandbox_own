#AWS Budgetsを使って月間のコストを監視する
resource "aws_budgets_budget" "budgets" {
  name         = "sandbox-budget-monthly"
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = "10"
  limit_unit   = "USD"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = "10"
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.notification_emails
  }
}
