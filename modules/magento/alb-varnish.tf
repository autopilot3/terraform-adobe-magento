resource "aws_alb" "alb_varnish" {
  name           = "${var.project}-varnish"
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
    Name      = "${var.project}-alb-varnish-public"
    Role      = "Load balancer for incoming external HTTP traffic"
    Terraform = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "varnish_http" {
  name     = "${var.project}-varnish-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    matcher = "200"
    path    = "/health_check_varnish"
  }

  tags = {
    Name      = "${var.project}-varnish-http"
    Role      = "External target group"
    Terraform = true
  }
}

resource "aws_alb_listener" "varnish_http" {
  load_balancer_arn = aws_alb.alb_varnish.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name      = "${var.project}-varnish-http"
    Role      = "ALB HTTP listener"
    Terraform = true
  }
}

# HTTPS listener
resource "aws_alb_listener" "varnish_https" {
  load_balancer_arn = aws_alb.alb_varnish.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.varnish_http.arn
    type             = "forward"
  }

  tags = {
    Name      = "${var.project}-varnish-https"
    Role      = "ALB HTTPS listener"
    Terraform = true
  }
}
