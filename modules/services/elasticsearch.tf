# -------------------
# | ElasticSearch    |
# -------------------
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


resource "random_shuffle" "elasticsearch_subnets" {
  input        = var.private_subnet_ids
  result_count = 1
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.elasticsearch_domain
  elasticsearch_version = var.es_version

  cluster_config {
    instance_count         = var.es_instance_count
    instance_type          = var.es_instance_type
    zone_awareness_enabled = var.es_instance_count == 1 ? false : true
  }

  vpc_options {
    subnet_ids = var.es_instance_count == 1 ? random_shuffle.elasticsearch_subnets.result : var.private_subnet_ids

    security_group_ids = [var.sg_elasticsearch_id]
  }

  encrypt_at_rest {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true",
    override_main_response_version           = false
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowES",
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain}/*"
        }
    ]
}
CONFIG

  tags = {
    Domain    = var.elasticsearch_domain
    Terraform = true
  }
}
