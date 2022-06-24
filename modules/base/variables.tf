# These variables have no default values and must be supplied when
# consuming this module.

variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "azs" {
  description = "Availability zones, used to place subnets etc"
  type        = list(string)
}

variable "management_addresses" {
  description = "IP addresses for management traffic"
  type        = list(string)
}

variable "base_ami_id" {
  type        = string
  description = "Base AMI for EC2 instances."
}

variable "domain_name" {
  type        = string
  description = "Add domain that is used e.g. bastion host connections."
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

variable "ssh_key_pair_name" {
  type        = string
  description = "Generated key-pair name in the AWS console."
}
