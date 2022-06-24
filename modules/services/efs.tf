# ------------------------
# | Elastic File System  |
# ------------------------

# Create new EFS storage

resource "aws_efs_file_system" "magento_data" {
  creation_token = "${var.project}-magento_data"
  encrypted      = true

  tags = {
    Name        = "${var.project}-efs-magento-data"
    Description = "EFS storage for Magento"
    Terraform   = true
  }

  lifecycle {
    ignore_changes = [creation_token]
  }

}

# Mount EFS to private subnets
resource "aws_efs_mount_target" "efs_private_subnet_mount" {
  for_each = toset(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.magento_data.id
  subnet_id       = each.key
  security_groups = [var.sg_efs_id]
}
