###
# Security Groups
###

output "sg_alb_varnish_id" {
  value = aws_security_group.alb_varnish.id
}
output "sg_ec2_varnish_id" {
  value = aws_security_group.ec2_varnish.id
}
output "sg_alb_magento_id" {
  value = aws_security_group.alb_magento.id
}
output "sg_ec2_magento_id" {
  value = aws_security_group.ec2_magento.id
}
output "sg_efs_id" {
  value = aws_security_group.efs.id
}
output "sg_ec2_amibuild_id" {
  value = aws_security_group.ec2_amibuild.id
}
output "sg_redis_id" {
  value = aws_security_group.redis.id
}
output "sg_awsmq_id" {
  value = aws_security_group.awsmq.id
}
output "sg_rds_id" {
  value = aws_security_group.rds.id
}
output "sg_elasticsearch_id" {
  value = aws_security_group.elasticsearch.id
}
