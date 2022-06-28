resource "aws_autoscaling_group" "magento" {
  name              = "magento-asg-${aws_launch_template.magento_launch_template.name}"
  min_size          = var.magento_autoscale_min
  max_size          = var.magento_autoscale_max
  desired_capacity  = var.magento_autoscale_desired
  health_check_type = "EC2"
  launch_template {
    id      = aws_launch_template.magento_launch_template.id
    version = aws_launch_template.magento_launch_template.latest_version
  }
  vpc_zone_identifier  = var.private_subnet_ids
  termination_policies = ["NewestInstance"]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
    }
    triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-magento-web-node"
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

resource "aws_autoscaling_policy" "autoscaling_magento_up" {
  name                   = "${var.project}-autoscaling_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.magento.name
}

resource "aws_autoscaling_policy" "autoscaling_magento_down" {
  name                   = "${var.project}-autoscaling_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.magento.name
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_magento_cpu_high" {
  alarm_name          = "${var.project}-cloudwatch_magento_cpu_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "Magento CPU over 90%"
  alarm_actions = [
    "${aws_autoscaling_policy.autoscaling_magento_up.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.magento.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudwatch_magento_cpu_low" {
  alarm_name          = "${var.project}-cloudwatch_magento_cpu_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "Magento CPU under 70%"
  alarm_actions = [
    "${aws_autoscaling_policy.autoscaling_magento_down.arn}"
  ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.magento.name}"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_magento_alb" {
  autoscaling_group_name = aws_autoscaling_group.magento.id
  lb_target_group_arn    = aws_alb_target_group.magento_http.arn
}

resource "aws_ssm_parameter" "magento_autoscale_name" {
  name  = "${var.ssm_path_prefix}magento_autoscale_name"
  type  = "String"
  value = aws_launch_template.magento_launch_template.name
  tags = {
    Terraform = true
  }
}
