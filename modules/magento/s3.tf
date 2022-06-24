resource "aws_s3_bucket" "magento_files" {
  bucket_prefix = "${var.project}-magento-files-"
  force_destroy = true

  tags = {
    Name        = "${var.project}-Magento Files"
    Description = "S3 bucket for Magento"
    Terraform   = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "magento_files" {
  bucket = aws_s3_bucket.magento_files.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "magento_files" {
  bucket = aws_s3_bucket.magento_files.id
  acl    = "private"
}

resource "aws_ssm_parameter" "magento_files_s3" {
  name  = "${var.ssm_path_prefix}magento_files_s3"
  type  = "String"
  value = aws_s3_bucket.magento_files.id
  tags = {
    Terraform = true
  }
}

resource "aws_s3_bucket" "lb_logs" {
  bucket = "${var.project}-lb-logs-bucket"

  tags = {
    Name      = "${var.project}-lb-logs-bucket"
    Terraform = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  acl    = "private"
}
