#################
# Common        #
#################
variable "base_ami_id" {
  type        = string
  description = "Base AMI for EC2 instances."
}

variable "region" {
  type        = string
  description = "AWS Region that will be used for deployment. This should match the region that was used when setting up the Terraform Cloud workspace"
}

variable "ssh_private_key" {
  type        = string
  description = "Admin SSH key name stored in secrets manager."
}

variable "ssh_username" {
  type        = string
  description = "Admin SSH username"
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Generated key-pair name in the AWS console."
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 Instance Type for building AMI"
}

variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type        = string
}

variable "ssm_path_prefix" {
  type        = string
  description = "SSM Path Prefix"
}

################################
# Magento Composer Credentials #
################################
variable "mage_composer_username" {
  type        = string
  description = "Magento auth.json username"
}

variable "mage_composer_password" {
  type        = string
  description = "Magento auth.json password"
}

##################################
# Magento Composer Configuration #
##################################
variable "mage_composer_release" {
  type        = string
  description = "The magento release to install"
}

###################################
#  SecurityGroups and Networking  #
###################################

variable "sg_ec2_amibuild_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "management_addresses" {
  description = "IP addresses for management traffic"
  type        = list(string)
}
