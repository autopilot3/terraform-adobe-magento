resource "aws_alb" "alb_magento" {
  name            = "${var.project}-magento"
  internal        = true
  security_groups = [var.sg_alb_magento_id]
  subnets         = var.private_subnet_ids

  # Deletion production should be true in production environment if we don't automatically generate varnish VCL
  enable_deletion_protection = false

  tags = {
    Name        = "${var.project}-alb-magento-private"
    Description = "Load balancer for incoming internal HTTP traffic"
    Terraform   = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "magento_http" {
  name     = "${var.project}-magento-http"
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
    Name      = "${var.project}-magento-http"
    Role      = "Internal target group"
    Terraform = true
  }
}

resource "aws_alb_listener" "alb_magento_listener_http" {
  load_balancer_arn = aws_alb.alb_magento.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.magento_http.arn
    type             = "forward"
  }

  tags = {
    Name      = "${var.project}-magento-http"
    Role      = "Internal HTTP listener"
    Terraform = true
  }

}
