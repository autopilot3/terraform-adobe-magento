resource "aws_cloudwatch_log_group" "magento-exception-log" {
  name              = "/${var.project}/magento-exception-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
    Terraform   = true
  }
}

resource "aws_cloudwatch_log_group" "magento-system-log" {
  name              = "/${var.project}/magento-system-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
    Terraform   = true
  }
}

resource "aws_cloudwatch_log_group" "magento-debug-log" {
  name              = "/${var.project}/magento-debug-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
    Terraform   = true
  }
}

resource "aws_cloudwatch_log_group" "magento-cron-log" {
  name              = "/${var.project}/magento-cron-log"
  retention_in_days = "90"

  tags = {
    Application = "magento"
    Terraform   = true
  }
}
