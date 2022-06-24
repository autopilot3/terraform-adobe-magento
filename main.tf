terraform {
  required_version = ">= 1.0.0"
}

# Create the basis for base module
module "account" {
  source          = "./modules/account"
  project         = var.project
  ssm_path_prefix = var.ssm_path_prefix
  domain_name     = var.domain_name
}

# Generate DB and RabbitMQ passwords
# Generate Magento encryption key
module "ssm" {
  source                    = "./modules/ssm"
  project                   = var.project
  ssm_path_prefix           = var.ssm_path_prefix
  magento_admin_firstname   = var.magento_admin_firstname
  magento_admin_lastname    = var.magento_admin_lastname
  magento_admin_email       = var.magento_admin_email
  magento_admin_username    = var.magento_admin_username
  magento_admin_password    = var.magento_admin_password
  magento_database_password = var.magento_database_password
}

# Run base module which includes Networking
module "base" {
  source = "./modules/base"

  project              = var.project
  vpc_cidr             = var.vpc_cidr
  management_addresses = var.management_addresses
  azs                  = var.azs
  base_ami_id          = data.aws_ami.selected.id
  domain_name          = var.domain_name
  ssh_key_pair_name    = var.ssh_key_pair_name

  ###
  # Existing VPC
  ###
  vpc_id                 = var.vpc_id
  vpc_public_subnet_ids  = var.vpc_public_subnet_ids
  vpc_private_subnet_ids = var.vpc_private_subnet_ids
  vpc_rds_subnet_ids     = var.vpc_rds_subnet_ids

  depends_on = [
    module.account
  ]
}

# Generate SSL certificate for your domain
module "acm" {
  source          = "./modules/acm"
  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id

  depends_on = [
    module.base
  ]
}


# Create services: RabbitMQ, Redis, CloudFront and RDS
module "services" {
  source = "./modules/services"
  # Common
  azs             = var.azs
  project         = var.project
  ssm_path_prefix = var.ssm_path_prefix

  # Services - RDS
  magento_db_name                         = var.magento_db_name
  rds_engine                              = var.rds_engine
  rds_engine_version                      = var.rds_engine_version
  rds_instance_type                       = var.rds_instance_type
  rds_multi_az                            = var.rds_multi_az
  skip_rds_snapshot_on_destroy            = var.skip_rds_snapshot_on_destroy
  magento_db_allocated_storage            = var.magento_db_allocated_storage
  magento_db_backup_retention_period      = var.magento_db_backup_retention_period
  magento_db_performance_insights_enabled = var.magento_db_performance_insights_enabled
  magento_db_username                     = var.magento_db_username
  magento_database_password               = var.magento_database_password

  # Services - RabbitMQ
  mq_engine_version    = var.mq_engine_version
  rabbitmq_username    = var.rabbitmq_username
  mq_instance_type     = var.mq_instance_type
  elasticsearch_domain = var.elasticsearch_domain
  es_version           = var.es_version
  mq_deployment_mode   = var.mq_deployment_mode

  # Services - Redis
  redis_instance_type_cache   = var.redis_instance_type_cache
  redis_instance_type_session = var.redis_instance_type_session
  redis_clusters_cache        = var.redis_clusters_cache
  redis_clusters_session      = var.redis_clusters_session
  redis_engine_version        = var.redis_engine_version

  # Services - Elasticsearch
  es_instance_count = var.es_instance_count
  es_instance_type  = var.es_instance_type

  # SES
  magento_admin_email = var.magento_admin_email

  # Network
  vpc_id             = var.vpc_id
  private_subnet_ids = var.vpc_private_subnet_ids
  public_subnet_ids  = var.vpc_public_subnet_ids
  rds_subnet_ids     = var.vpc_rds_subnet_ids

  # Security
  sg_efs_id           = module.base.sg_efs_id
  sg_redis_id         = module.base.sg_redis_id
  sg_awsmq_id         = module.base.sg_awsmq_id
  sg_rds_id           = module.base.sg_rds_id
  sg_elasticsearch_id = module.base.sg_elasticsearch_id

  depends_on = [
    module.base
  ]
}

# Create Magento AMI
module "magento-ami" {
  source                 = "./modules/magento-ami"
  region                 = var.region
  project                = var.project
  ssm_path_prefix        = var.ssm_path_prefix
  base_ami_id            = data.aws_ami.selected.id
  ssh_private_key        = var.ssh_private_key
  ssh_username           = var.ssh_username
  mage_composer_username = var.mage_composer_username
  mage_composer_password = var.mage_composer_password
  vpc_id                 = var.vpc_id
  public_subnet_ids      = var.vpc_public_subnet_ids
  management_addresses   = var.management_addresses
  ssh_key_pair_name      = var.ssh_key_pair_name
  ec2_instance_type      = "t3.medium"
  sg_ec2_amibuild_id     = module.base.sg_ec2_amibuild_id
  mage_composer_release  = var.mage_composer_release

  depends_on = [
    module.services
  ]
}

# Create Varnish AMI
module "varnish-ami" {
  source               = "./modules/varnish-ami"
  region               = var.region
  project              = var.project
  ssm_path_prefix      = var.ssm_path_prefix
  base_ami_id          = data.aws_ami.selected.id
  ssh_private_key      = var.ssh_private_key
  ssh_username         = var.ssh_username
  vpc_id               = var.vpc_id
  public_subnet_ids    = var.vpc_public_subnet_ids
  management_addresses = var.management_addresses
  ssh_key_pair_name    = var.ssh_key_pair_name
  ec2_instance_type    = "t3.medium"
  sg_ec2_amibuild_id   = module.base.sg_ec2_amibuild_id

  depends_on = [
    module.services
  ]
}


# Create ALB/ASG, CloudFront and Magento EC2 instances
module "magento" {
  source = "./modules/magento"
  # Common
  project           = var.project
  ssm_path_prefix   = var.ssm_path_prefix
  ssh_private_key   = var.ssh_private_key
  ssh_username      = var.ssh_username
  ssh_key_pair_name = var.ssh_key_pair_name
  # Network
  vpc_id             = var.vpc_id
  private_subnet_ids = var.vpc_private_subnet_ids
  public_subnet_ids  = var.vpc_public_subnet_ids
  vpc_cidr           = var.vpc_cidr
  # Security
  sg_alb_magento_id = module.base.sg_alb_magento_id
  sg_alb_varnish_id = module.base.sg_alb_varnish_id
  sg_ec2_magento_id = module.base.sg_ec2_magento_id
  sg_ec2_varnish_id = module.base.sg_ec2_varnish_id
  sg_efs_id         = module.base.sg_efs_id

  lb_access_logs_enabled = var.lb_access_logs_enabled

  # AMIs
  magento_ami     = module.magento-ami.magento_ami_id
  varnish_ami     = module.varnish-ami.varnish_ami_id
  alb_cert_arn    = module.acm.cert_arn
  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id

  # Instance Config
  ec2_instance_type_magento = var.ec2_instance_type_magento
  ec2_instance_type_varnish = var.ec2_instance_type_varnish

  # ASGs
  magento_autoscale_desired = var.magento_autoscale_desired
  magento_autoscale_max     = var.magento_autoscale_max
  magento_autoscale_min     = var.magento_autoscale_min
  varnish_autoscale_desired = var.varnish_autoscale_desired
  varnish_autoscale_max     = var.varnish_autoscale_max
  varnish_autoscale_min     = var.varnish_autoscale_min

  depends_on = [
    module.magento-ami,
    module.varnish-ami
  ]
}
