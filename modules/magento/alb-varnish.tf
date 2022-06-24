# ------------------
# | Load balancers |
# ------------------

##
# EXTERNAL Load Balancer
##

resource "aws_alb" "alb_external" {
  name            = "${var.project}-alb-external"
  internal        = false
  security_groups = [var.sg_alb_varnish_id]
  subnets         = var.public_subnet_ids

  # Deletion production should be true in production environment
  enable_deletion_protection = false

  # Enable access logging for production usage
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "lb"
    enabled = var.lb_access_logs_enabled
  }

  tags = {
    Name      = "${var.project}-alb-external"
    Role      = "Load balancer for incoming external HTTP traffic"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "alb_tg_external" {
  name     = "${var.project}-alb-tg-external"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    matcher = "200"
    path    = "/health_check_varnish"
  }

  tags = {
    Name      = "${var.project}-alb-external-target-group"
    Role      = "External target group"
    Terraform = true
  }
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = aws_alb.alb_external.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_external.arn
    type             = "forward"
  }

  tags = {
    Name      = "${var.project}-alb-http-listener"
    Role      = "ALB HTTP listener"
    Terraform = true
  }
}

# HTTPS listener
resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn = aws_alb.alb_external.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_external.arn
    type             = "forward"
  }

  tags = {
    Name      = "${var.project}-alb-https-listener"
    Role      = "ALB HTTPS listener"
    Terraform = true
  }
}
