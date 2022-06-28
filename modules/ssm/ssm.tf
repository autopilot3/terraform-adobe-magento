######################
# Generate randoms   #
######################

resource "random_string" "random_encryption_key" {
  length  = 32
  special = false
  upper   = false
}

resource "aws_ssm_parameter" "magento_admin_password" {
  name  = "${var.ssm_path_prefix}magento_admin_password"
  type  = "SecureString"
  value = var.magento_admin_password
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_admin_firstname" {
  name  = "${var.ssm_path_prefix}magento_admin_firstname"
  type  = "String"
  value = var.magento_admin_firstname
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_admin_lastname" {
  name  = "${var.ssm_path_prefix}magento_admin_lastname"
  type  = "String"
  value = var.magento_admin_lastname
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_admin_email" {
  name  = "${var.ssm_path_prefix}magento_admin_email"
  type  = "String"
  value = var.magento_admin_email
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "magento_admin_username" {
  name  = "${var.ssm_path_prefix}magento_admin_username"
  type  = "String"
  value = var.magento_admin_username
  tags = {
    Terraform = true
  }
}

############################
# Database Encryption Keys #
############################

resource "aws_ssm_parameter" "magento_crypt_key" {
  name  = "${var.ssm_path_prefix}magento_crypt_key"
  type  = "SecureString"
  value = random_string.random_encryption_key.result
  tags = {
    Terraform = true
  }
}

################
# Project Name #
################

resource "aws_ssm_parameter" "project_name" {
  name  = "${var.ssm_path_prefix}project_name"
  type  = "String"
  value = var.project
  tags = {
    Terraform = true
  }
}

################
# Base Domain  #
################

resource "aws_ssm_parameter" "base_domain" {
  name  = "${var.ssm_path_prefix}base_domain"
  type  = "String"
  value = var.magento_base_domain
  tags = {
    Terraform = true
  }
}
