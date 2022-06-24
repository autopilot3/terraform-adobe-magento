# ------------------
# | Load balancers |
# ------------------


###
# INTERNAL Load Balancer
###

resource "aws_alb" "alb_internal" {
  name            = "${var.project}-alb-internal"
  internal        = true
  security_groups = [var.sg_alb_magento_id]
  subnets         = var.private_subnet_ids

  # Deletion production should be true in production environment if we don't automatically generate varnish VCL
  enable_deletion_protection = false

  tags = {
    Name        = "${var.project}-alb-internal"
    Description = "Load balancer for incoming internal HTTP traffic"
    Terraform   = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "alb_tg_internal" {
  name     = "${var.project}-alb-tg-internal"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    timeout  = "3"
    interval = "5"
    matcher  = "200"
    path     = "/health_check.php"
  }

  tags = {
    Name      = "${var.project}-alb-internal-target-group"
    Role      = "Internal target group"
    Terraform = true
  }
}

resource "aws_alb_listener" "alb_internal_listener_http" {
  load_balancer_arn = aws_alb.alb_internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg_internal.arn
    type             = "forward"
  }

  tags = {
    Name      = "${var.project}-alb-internal-http-listener"
    Role      = "Internal HTTP listener"
    Terraform = true
  }

}

##
# ALB redirection rules
##

# Always redirect HTTP to HTTPS

resource "aws_lb_listener_rule" "ext_listener_http_to_https" {
  listener_arn = aws_alb_listener.alb_listener_http.arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = {
    Name      = "external-http-to-https"
    Role      = "External listener for http to https redirection"
    Terraform = true
  }
}
