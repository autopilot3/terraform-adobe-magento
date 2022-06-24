# -------------------
# | Security groups |
# -------------------

resource "aws_security_group" "alb_varnish" {
  name        = "${var.project}-alb-varnish"
  description = "ALB Varnish"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-alb-varnish"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "alb_varnish_in_global_http" {
  security_group_id = aws_security_group.alb_varnish.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "alb_varnish_in_global_https" {
  security_group_id = aws_security_group.alb_varnish.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "alb_varnish_out_ec2_varnish_http" {

  security_group_id = aws_security_group.alb_varnish.id

  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "TCP"

  source_security_group_id = aws_security_group.ec2_varnish.id
}

resource "aws_security_group" "ec2_varnish" {
  name        = "${var.project}-ec2-varnish"
  description = "EC2 Varnish"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-ec2-varnish"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "ec2_varnish_in_alb_varnish_http" {
  security_group_id = aws_security_group.ec2_varnish.id

  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "TCP"

  source_security_group_id = aws_security_group.alb_varnish.id
}
resource "aws_security_group_rule" "ec2_varnish_out_alb_magento_http" {
  security_group_id = aws_security_group.ec2_varnish.id

  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "TCP"

  source_security_group_id = aws_security_group.alb_magento.id
}
resource "aws_security_group_rule" "ec2_varnish_out_world" {
  security_group_id = aws_security_group.ec2_varnish.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "alb_magento" {
  name        = "${var.project}-alb-magento"
  description = "ALB Magento"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-alb-magento"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "alb_magento_in_ec2_varnish_http" {
  security_group_id = aws_security_group.alb_magento.id

  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "TCP"

  source_security_group_id = aws_security_group.ec2_varnish.id

}
resource "aws_security_group_rule" "alb_magento_out_ec2_magento_http" {

  security_group_id = aws_security_group.alb_magento.id

  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "TCP"

  source_security_group_id = aws_security_group.ec2_magento.id

}

resource "aws_security_group" "ec2_magento" {
  name        = "${var.project}-ec2-magento"
  description = "EC2 Magento"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-ec2-magento"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "ec2_magento_in_alb_magento_http" {
  security_group_id = aws_security_group.ec2_magento.id

  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "TCP"

  source_security_group_id = aws_security_group.alb_magento.id
}
resource "aws_security_group_rule" "ec2_magento_out_world" {
  security_group_id = aws_security_group.ec2_magento.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ec2_magento_out_efs" {
  security_group_id = aws_security_group.ec2_magento.id

  type      = "egress"
  from_port = 2049
  to_port   = 2049
  protocol  = "TCP"

  source_security_group_id = aws_security_group.efs.id
}

resource "aws_security_group" "efs" {
  name        = "${var.project}-efs-magento"
  description = "EFS Magento"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-efs-magento"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "efs_in_ec2_magento" {
  security_group_id = aws_security_group.efs.id

  type      = "ingress"
  from_port = 2049
  to_port   = 2049
  protocol  = "TCP"

  source_security_group_id = aws_security_group.ec2_magento.id
}

resource "aws_security_group" "ec2_amibuild" {
  name        = "${var.project}-ec2-amibuild"
  description = "EC2 AMI Build"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-ec2-amibuild"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "ec2_amibuild_in_ssh" {
  security_group_id = aws_security_group.ec2_amibuild.id

  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "TCP"

  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "ec2_amibuild_out_world" {
  security_group_id = aws_security_group.ec2_amibuild.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "redis" {
  name        = "${var.project}-redis"
  description = "Redis"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-redis"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "redis_in_ec2_magento" {
  security_group_id = aws_security_group.redis.id

  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "TCP"

  source_security_group_id = aws_security_group.ec2_magento.id
}
resource "aws_security_group_rule" "redis_in_self" {
  security_group_id = aws_security_group.redis.id

  type      = "ingress"
  from_port = 6379
  to_port   = 6379
  protocol  = "TCP"

  self = true
}
resource "aws_security_group_rule" "redis_out_self" {
  security_group_id = aws_security_group.redis.id

  type      = "egress"
  from_port = 6379
  to_port   = 6379
  protocol  = "TCP"

  self = true
}


resource "aws_security_group" "awsmq" {
  name        = "${var.project}-awsmq"
  description = "AWS MQ (RabbitMQ)"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-awsmq"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "awsmq_in_ec2_magento" {
  security_group_id = aws_security_group.awsmq.id

  type      = "ingress"
  from_port = 5671
  to_port   = 5671
  protocol  = "TCP"

  source_security_group_id = aws_security_group.ec2_magento.id
}

resource "aws_security_group_rule" "awsmq_in_self" {
  security_group_id = aws_security_group.awsmq.id

  type      = "ingress"
  from_port = 5671
  to_port   = 5671
  protocol  = "TCP"

  self = true
}

resource "aws_security_group_rule" "awsmq_out_self" {
  security_group_id = aws_security_group.awsmq.id

  type      = "egress"
  from_port = 5671
  to_port   = 5671
  protocol  = "TCP"

  self = true
}

resource "aws_security_group" "rds" {
  name        = "${var.project}-rds"
  description = "rds"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-rds"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "rds_in_ec2_magento" {
  security_group_id = aws_security_group.rds.id

  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "TCP"

  source_security_group_id = aws_security_group.ec2_magento.id
}

resource "aws_security_group" "elasticsearch" {
  name        = "${var.project}-elasticsearch"
  description = "elasticsearch"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project}-elasticsearch"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "elasticsearch_in_ec2_magento_https" {
  security_group_id = aws_security_group.elasticsearch.id

  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "TCP"

  source_security_group_id = aws_security_group.ec2_magento.id
}
