provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.0.1"
}

# Magento Quickstart
module "magento" {
  source                    = "../../"
  region                    = var.region
  azs                       = var.azs
  project                   = var.project
  base_ami_os               = var.base_ami_os
  domain_name               = var.domain_name
  ssh_private_key           = var.ssh_private_key
  ssh_key_pair_name         = var.ssh_key_pair_name
  ssh_username              = var.ssh_username
  mage_composer_username    = var.mage_composer_username
  mage_composer_password    = var.mage_composer_password
  magento_admin_firstname   = var.magento_admin_firstname
  magento_admin_lastname    = var.magento_admin_lastname
  magento_admin_username    = var.magento_admin_username
  magento_admin_password    = var.magento_admin_password
  magento_admin_email       = var.magento_admin_email
  magento_database_password = var.magento_database_password
  cert                      = var.cert_arn
  elasticsearch_domain      = var.elasticsearch_domain
  rabbitmq_username         = var.rabbitmq_username
  management_addresses      = var.management_addresses

  vpc_cidr = var.vpc_cidr
  ###
  # Existing VPC
  ###
  vpc_id                 = var.vpc_id
  vpc_public_subnet_ids  = var.vpc_public_subnet_ids
  vpc_private_subnet_ids = var.vpc_private_subnet_ids
  vpc_rds_subnet_ids     = var.vpc_rds_subnet_ids
}
