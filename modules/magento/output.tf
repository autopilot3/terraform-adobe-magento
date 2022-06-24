output "alb_varnish_dns_name" {
  value = aws_alb.alb_varnish.dns_name
}

output "magento_files_s3" {
  value = aws_s3_bucket.magento_files.bucket_domain_name
}
