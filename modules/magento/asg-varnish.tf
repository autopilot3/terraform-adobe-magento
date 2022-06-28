# Varnish ASG
resource "aws_autoscaling_group" "varnish" {
  name              = "varnish-asg-${aws_launch_template.varnish_launch_template.name}"
  min_size          = var.varnish_autoscale_min
  max_size          = var.varnish_autoscale_max
  desired_capacity  = var.varnish_autoscale_desired
  health_check_type = "EC2"
  launch_template {
    id      = aws_launch_template.varnish_launch_template.id
    version = aws_launch_template.varnish_launch_template.latest_version
  }
  vpc_zone_identifier = var.private_subnet_ids

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-varnish-node"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      load_balancers,
      target_group_arns
    ]
  }
}
