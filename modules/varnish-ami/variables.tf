#################
# Common        #
#################
variable "base_ami_id" {
  type        = string
  description = "Base AMI for EC2 instances."
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
