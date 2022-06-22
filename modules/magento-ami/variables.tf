#################
# Common        #
#################
variable "base_ami_id" {
  type        = string
  description = "Base AMI for EC2 instances."
}

variable "ssh_key_name" {
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
  type = string
  description = "EC2 Instance Type for building AMI"
  value = "t3.medium"
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
  value       = "magento/project-community-edition"
}

###################################
#  SecurityGroups and Networking  #
###################################
variable "sg_allow_all_out_id" {
  description = "Security group ID for allowing outbound connections"
  type        = string
}

variable "public_subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "management_addresses" {
  description = "IP addresses for management traffic"
  type        = list(string)
}
