# ------------------
# | RDS            |
# ------------------

resource "aws_db_subnet_group" "magento_rds" {
  name       = "${var.project}-magento-rds"
  subnet_ids = var.rds_subnet_ids
  tags = {
    Name      = "Subnet group for RDS"
    Terraform = true
  }
}

resource "random_string" "db_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_db_instance" "magento_db" {
  allocated_storage            = var.magento_db_allocated_storage
  backup_retention_period      = var.magento_db_backup_retention_period
  db_subnet_group_name         = aws_db_subnet_group.magento_rds.name
  identifier                   = "${var.project}-magento-db"
  engine                       = var.rds_engine
  engine_version               = var.rds_engine_version
  allow_major_version_upgrade  = false
  auto_minor_version_upgrade   = true
  instance_class               = var.rds_instance_type
  multi_az                     = var.rds_multi_az
  port                         = 3306
  db_name                      = var.magento_db_name
  username                     = var.magento_db_username
  password                     = var.magento_database_password
  vpc_security_group_ids       = [var.sg_rds_id]
  skip_final_snapshot          = var.skip_rds_snapshot_on_destroy
  final_snapshot_identifier    = "${var.project}-magento-final-snapshot-${random_string.db_suffix.result}"
  depends_on                   = [aws_db_subnet_group.magento_rds]
  performance_insights_enabled = var.magento_db_performance_insights_enabled
  storage_encrypted            = true

  timeouts {
    create = "60m"
  }

  tags = {
    Name      = "${var.project}-magento-rds-database"
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_database_password" {
  name  = "${var.ssm_path_prefix}magento_database_password"
  type  = "SecureString"
  value = var.magento_database_password
  tags = {
    Terraform = true
  }
}
