#################
# Common        #
#################
variable "magento_ami" {
  type = string
}

variable "varnish_ami" {
  type = string
}

variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type        = string
}

variable "ssm_path_prefix" {
  type        = string
  description = "SSM Path Prefix"
}

variable "domain_name" {
  type        = string
  description = "Add domain name for the project."
}

variable "alb_cert_arn" {
  type        = string
  description = "ACM Certificate ARN for the public facing ALB"
}

variable "route53_zone_id" {
  type        = string
  description = "Route53 Zone ID for the above domain"
}

variable "ssh_key_name" {
  type        = string
  description = "Admin SSH key name stored in secrets manager."
}

variable "ssh_username" {
  type        = string
  description = "Admin SSH username."
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Generated key-pair name in the AWS console."
}

####################
#  Networking      #
####################
variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}


####################
#  SecurityGroups  #
####################

variable "sg_alb_varnish_id" {
  type = string
}
variable "sg_ec2_varnish_id" {
  type = string
}
variable "sg_alb_magento_id" {
  type = string
}
variable "sg_ec2_magento_id" {
  type = string
}
variable "sg_efs_id" {
  type = string
}

####################
# LB booleans      #
####################
variable "lb_access_logs_enabled" {
  type        = bool
  description = "Enable load balancer accesslogs to s3 bucket"
}

####################################################
# Magento autoscaling group min/max/desired values #
####################################################
variable "magento_autoscale_min" {
}
variable "magento_autoscale_max" {
}
variable "magento_autoscale_desired" {
}

#############################
# Magento EC2 Instance Size #
#############################
variable "ec2_instance_type_magento" {
}

####################################################
# Varnish autoscaling group min/max/desired values #
####################################################
variable "varnish_autoscale_min" {
}
variable "varnish_autoscale_max" {
}
variable "varnish_autoscale_desired" {
}

#############################
# Varnish EC2 Instance Size #
#############################
variable "ec2_instance_type_varnish" {
}
