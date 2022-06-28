# Varnish cfg
locals {
  /* removed: sed -i "s/DNS_RESOLVER/${cidrhost(var.vpc_cidr, "2")}/g" /etc/nginx/conf.d/varnish.conf */
  varnish_userdata = <<-EOF
    #!/bin/bash
    sudo -u ec2-user crontab -r
    sed -i "s/DNS_RESOLVER/${cidrhost(var.vpc_cidr, "2")}/g" /etc/nginx/conf.d/varnish.conf
    sed -i "s/MAGENTO_INTERNAL_ALB/${aws_alb.alb_magento.dns_name}/g" /etc/nginx/conf.d/varnish.conf
    sed -i "s/MAGENTO_INTERNAL_ALB/${aws_alb.alb_magento.dns_name}/g" /etc/varnish/backends.vcl
    systemctl start nginx
    systemctl restart varnish
  EOF
}

resource "aws_launch_template" "varnish_launch_template" {
  name_prefix   = "${var.project}-varnish-"
  image_id      = var.varnish_ami
  instance_type = var.ec2_instance_type_varnish
  key_name      = var.ssh_key_pair_name
  iam_instance_profile {
    name = aws_iam_instance_profile.varnish_host_profile.id
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_ec2_varnish_id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      encrypted   = true
    }
  }

  user_data = base64encode(local.varnish_userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_varnish_alb" {
  autoscaling_group_name = aws_autoscaling_group.varnish.id
  lb_target_group_arn    = aws_alb_target_group.varnish_http.arn
}
