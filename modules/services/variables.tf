####################
#  Region and AZs  #
####################
variable "azs" {
  description = "Availability zones used to place subnets etc"
  type        = list(string)
}

#################
# Common        #
#################
variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type        = string
}

variable "ssm_path_prefix" {
  type        = string
  description = "SSM Path Prefix"
}

#variable "route53_internal_zone_id" {
#  description = "Route53 internal zone's ID"
#  type = string
#}

####################
#  Networking      #
####################
variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "rds_subnet_ids" {
  type = list(string)
}

####################
#  SecurityGroups  #
####################
variable "sg_efs_id" {
  type = string
}
variable "sg_redis_id" {
  type = string
}
variable "sg_awsmq_id" {
  type = string
}
variable "sg_rds_id" {
  type = string
}
variable "sg_elasticsearch_id" {
  type = string
}

####################
#  RDS             #
####################
variable "skip_rds_snapshot_on_destroy" {
  description = "Skip the creation of a snapshot when db resource is destroyed?"
}

variable "magento_db_backup_retention_period" {
  type = string
}

variable "magento_db_allocated_storage" {
  type = string
}

variable "magento_db_performance_insights_enabled" {
  description = "Enable performace_insights for RDS DB"
  type        = bool
}

# Variables with default values. You do not have to set these, but you can.
variable "magento_db_name" {
  description = "RDS database name for Magento"
  type        = string
}

variable "magento_db_username" {
  description = "RDS username for Magento DB"
  type        = string
}

variable "magento_database_password" {
  description = "RDS username for Magento DB"
  type        = string
}

#######################
# Redis #
#######################

variable "redis_engine_version" {
  type        = string
  description = "Redis engine version"
}

variable "redis_instance_type_cache" {
  type = string
}

variable "redis_clusters_cache" {
  type = number
}

variable "redis_instance_type_session" {
}

variable "redis_clusters_session" {
  type = number
}

#######################
# RDS #
#######################

variable "rds_engine" {
  type = string
}

variable "rds_engine_version" {
  type = string
}

variable "rds_instance_type" {
  type = string
}

#######################
# RabbitMQ            #
#######################
variable "mq_instance_type" {
}

variable "mq_engine_version" {
  type = string
}

variable "rabbitmq_username" {
  description = "Username for RabbitMQ"
  type        = string
}

#######################
# ElasticSearch       #
#######################
variable "elasticsearch_domain" {
  type = string
}

variable "es_version" {
  type = string
}

variable "es_instance_type" {
  type = string
}

variable "es_instance_count" {
  type = number
}

########
# SES  #
########
variable "magento_admin_email" {
  description = "Magento Admin email used for SES."
  type        = string
}

########################################################
# EC2 instance types used within the module            #
########################################################
