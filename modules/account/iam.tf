##########################
# IAM roles and policies #
##########################

# AWS Backup Related policies

resource "aws_iam_role" "aws_backup_role" {
  name               = "AWSBackupRole"
  assume_role_policy = file("${path.module}/iam_policies/backup_iam_role.json")
}

resource "aws_iam_role_policy_attachment" "policy_to_backup_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup_role.name
}

##
# SES SMTP User
##
resource "aws_iam_user" "smtp_user" {
  name = "ses-smtp-user"
}

resource "aws_iam_access_key" "smtp_user" {
  user = aws_iam_user.smtp_user.name
}

resource "aws_iam_policy" "ses_sender" {
  name        = "ses_send_policy"
  description = "Send emails via SES"
  policy      = file("${path.module}/iam_policies/ses-smtp-policy.json")
}

resource "aws_iam_user_policy_attachment" "smtp_policy_attach" {
  user       = aws_iam_user.smtp_user.name
  policy_arn = aws_iam_policy.ses_sender.arn
}


# Save SMTP credentials to Parameter Store
resource "aws_ssm_parameter" "smtp_user" {
  name  = "${var.ssm_path_prefix}smtp_user"
  type  = "String"
  value = aws_iam_access_key.smtp_user.id
  tags = {
    Terraform = true
  }
}

resource "aws_ssm_parameter" "smtp_pass" {
  name  = "${var.ssm_path_prefix}smtp_pass"
  type  = "SecureString"
  value = aws_iam_access_key.smtp_user.ses_smtp_password_v4
  tags = {
    Terraform = true
  }
}
