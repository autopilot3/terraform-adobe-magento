#####################
# Project specifics #
#####################

variable "project" {
  type        = string
  description = "Name of the project."
}

variable "ssm_path_prefix" {
  type        = string
  description = "SSM Path Prefix"
  default     = "/"
}

variable "domain_name" {
  type        = string
  description = "Add domain name for the project."
  default     = null
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 Zone ID for the above domain"
}

variable "ssh_private_key" {
  type      = string
  sensitive = true
}

variable "ssh_username" {
  type = string
}

variable "ssh_key_pair_name" {
  type = string
}

variable "magento_admin_firstname" {
  description = "Firstname for Magento admin."
  type        = string
}

variable "magento_admin_lastname" {
  description = "Lastname for Magento admin."
  type        = string
}

variable "magento_admin_username" {
  description = "Username for Magento admin."
  type        = string
}
variable "magento_admin_password" {
  description = "Password for Magento admin."
  type        = string
}

variable "magento_db_username" {
  description = "RDS username for Magento DB"
  type        = string
}

variable "magento_database_password" {
  description = "Password for Magento DB."
  type        = string
  sensitive   = true
}

variable "magento_admin_email" {
  description = "Email address for Magento admin."
  type        = string
}

variable "mage_composer_release" {
  type        = string
  description = "The magento release to install"
  default     = "magento/project-community-edition"
}

##############
#  Base AMI  #
##############
locals {
  os_ami_queries = {
    debian_10 = {
      most_recent = true
      owners      = ["136693071363"] # debian
      filters = {
        name = ["debian-11-amd64*"]
      }
    }
    amazon_linux_2 = {
      most_recent = true
      owners      = ["amazon"]
      filters = {
        name = ["amzn2-ami-hvm-*-x86_64*"]
      }
    }
  }
  ami_query = local.os_ami_queries[var.base_ami_os]
}

data "aws_ami" "selected" {
  most_recent = true
  owners      = local.ami_query.owners

  dynamic "filter" {
    for_each = local.ami_query.filters
    content {
      name   = filter.key
      values = filter.value
    }
  }
}

variable "base_ami_ids" {
  description = "Base AMI for Magento EC2 instances. Amazon Linux 2 or Debian 10."
  type        = map(string)
  default = {
    "amazon_linux_2" = "ami-02e136e904f3da870",
    "debian_10"      = "ami-07d02ee1eeb0c996c"
  }
}

variable "base_ami_os" {
  type = string
}


####################################################
# Magento autoscaling group min/max/desired values #
####################################################
variable "magento_autoscale_min" {
  default = 1
}
variable "magento_autoscale_max" {
  default = 1
}
variable "magento_autoscale_desired" {
  default = 1
}

#############################
# Magento EC2 Instance Size #
#############################
variable "ec2_instance_type_magento" {
  default = "m6i.large"
}


####################################################
# Varnish autoscaling group min/max/desired values #
####################################################
variable "varnish_autoscale_min" {
  default = 1
}
variable "varnish_autoscale_max" {
  default = 1
}
variable "varnish_autoscale_desired" {
  default = 1
}

#############################
# Varnish EC2 Instance Size #
#############################
variable "ec2_instance_type_varnish" {
  default = "m6i.large"
}


#######
# AZs #
#######
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a"]
}

##########################################
#  Networking and External IP addresses  #
##########################################
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "management_addresses" {
  description = "Whitelisted IP addresses for e.g. Security Groups"
  type        = list(string)
}

variable "mage_composer_username" {
  type        = string
  description = "Magento auth.json username"
}

variable "mage_composer_password" {
  type        = string
  description = "Magento auth.json password"
}


##################
# Load Balancing #
##################

variable "lb_access_logs_enabled" {
  type        = bool
  description = "Enable load balancer accesslogs to s3 bucket"
  default     = false
}

##################
#  RDS Database  #
##################

variable "magento_db_backup_retention_period" {
  default = 3
}

variable "magento_db_allocated_storage" {
  default = 60
}

variable "skip_rds_snapshot_on_destroy" {
  type        = bool
  description = "Take a final snapshot on RDS destroy?"
  default     = false
}

variable "magento_db_performance_insights_enabled" {
  default = true
}

variable "rds_instance_type" {
  default = "db.r5.2xlarge"
  type    = string
}

variable "rds_multi_az" {
  type = bool
}

variable "magento_db_name" {
  description = "RDS database name for Magento"
  type        = string
}


variable "rds_engine" {
  type = string
}

variable "rds_engine_version" {
  type = string
}

##################
#  ElasticSearch #
##################

variable "elasticsearch_domain" {
  type        = string
  description = "ElasticSearch domain"
}

variable "es_version" {
  default = "7.4"
  type    = string
}

variable "es_instance_type" {
  default = "m5.large.elasticsearch"
  type    = string
}

variable "es_instance_count" {
  type    = number
  default = 2
}

##################
#  RabbitMQ      #
##################

variable "rabbitmq_username" {
  type        = string
  description = "Username for RabbitMQ"
}

variable "mq_instance_type" {
  default = "mq.m5.large"
}


variable "mq_engine_version" {
  type = string
}

variable "mq_deployment_mode" {
  type    = string
  default = "CLUSTER_MULTI_AZ"
}


##################
#  Redis      #
##################



variable "redis_engine_version" {
  type    = string
  default = "6.x"
}

variable "redis_instance_type_cache" {
  type    = string
  default = "cache.m5.large"
}

variable "redis_clusters_cache" {
  type    = number
  default = 2
}

variable "redis_instance_type_session" {
  default = "cache.m5.large"
}

variable "redis_clusters_session" {
  type    = number
  default = 2
}

################################################
#  Existing VPC Configurations                 #
################################################
variable "vpc_id" {
  type = string
}
variable "vpc_public_subnet_ids" {
  type = list(string)
}

variable "vpc_private_subnet_ids" {
  type = list(string)
}

variable "vpc_rds_subnet_ids" {
  type = list(string)
}
