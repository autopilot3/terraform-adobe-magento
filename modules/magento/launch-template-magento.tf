##
# Launch configurations
##

# Magento cfg
locals {
  magento_userdata = <<-EOF
    #!/bin/bash
    sleep $[ ( $RANDOM % 10 )  + 1 ]s
    sudo -u ec2-user crontab -r
    sudo su - magento -c "/tmp/ec2_install/scripts/magento-setup.sh"
  EOF
}

resource "aws_launch_template" "magento_launch_template" {
  name_prefix   = "${var.project}-magento-web-"
  image_id      = var.magento_ami
  instance_type = var.ec2_instance_type_magento
  iam_instance_profile {
    name = aws_iam_instance_profile.magento_host_profile.id
  }
  key_name = var.ssh_key_pair_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.sg_ec2_magento_id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      encrypted   = true
    }
  }

  user_data = base64encode(local.magento_userdata)

  lifecycle {
    create_before_destroy = true
  }
}
