output "alb_external_dns_name" {
  value = aws_alb.alb_external.dns_name
}

output "magento_files_s3" {
  value = aws_s3_bucket.magento_files.bucket_domain_name
}
