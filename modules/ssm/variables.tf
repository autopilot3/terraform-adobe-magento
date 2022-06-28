variable "project" {
  description = "Project identifier, used in e.g. S3 bucket naming"
  type        = string
}

variable "ssm_path_prefix" {
  type        = string
  description = "SSM Path Prefix"
}

variable "magento_admin_email" {
  description = "Email address for Magento admin."
  type        = string
}

variable "magento_admin_firstname" {
  description = "Firstname for Magento admin."
  type        = string
}

variable "magento_admin_lastname" {
  description = "Lastname for Magento admin."
  type        = string
}

variable "magento_admin_password" {
  description = "Password for Magento admin."
  type        = string
}

variable "magento_admin_username" {
  description = "Username for Magento admin."
  type        = string
}

variable "magento_database_password" {
  description = "Password for Magento DB."
  type        = string
}

variable "magento_base_domain" {
  description = "Base domain for Magento."
  type        = string
}
