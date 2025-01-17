resource "random_string" "mq_password" {
  length  = 16
  special = false
  upper   = true
}

resource "random_shuffle" "mq_subnet_ids" {
  input        = var.private_subnet_ids
  result_count = 1
}

resource "aws_mq_broker" "rabbit_mq" {
  broker_name = "${var.project}-rabbitmq"

  engine_type                = "RabbitMQ"
  engine_version             = var.mq_engine_version
  host_instance_type         = var.mq_instance_type
  auto_minor_version_upgrade = true
  deployment_mode            = var.mq_deployment_mode
  publicly_accessible        = false
  subnet_ids                 = var.mq_deployment_mode == "SINGLE_INSTANCE" ? random_shuffle.mq_subnet_ids.result : var.private_subnet_ids

  security_groups = [var.sg_awsmq_id]

  user {
    username = var.rabbitmq_username
    password = random_string.mq_password.result
  }

  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "rabbitmq_password" {
  name  = "${var.ssm_path_prefix}rabbitmq_password"
  type  = "SecureString"
  value = random_string.mq_password.result
  tags = {
    Terraform = true
  }
}
