resource "random_shuffle" "magento-ami-subnet" {
  input        = var.public_subnet_ids
  result_count = 1
}


resource "aws_ssm_parameter" "mage_composer_username" {
  name      = "${var.ssm_path_prefix}mage_composer_username"
  type      = "SecureString"
  value     = var.mage_composer_username
  overwrite = true
}

resource "aws_ssm_parameter" "mage_composer_password" {
  name      = "${var.ssm_path_prefix}mage_composer_password"
  type      = "SecureString"
  value     = var.mage_composer_password
  overwrite = true
}

locals {
  instance_tag_name = "${var.project}-magento-ami-instance" # used in the destroy script below, ensure unique to this project
}

resource "aws_instance" "magento_instance" {
  ami                         = var.base_ami_id
  instance_type               = var.ec2_instance_type
  key_name                    = var.ssh_key_pair_name
  subnet_id                   = random_shuffle.magento-ami-subnet.result[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_ec2_amibuild_id]
  iam_instance_profile        = aws_iam_instance_profile.magento_ami_host_profile.id

  provisioner "file" {
    source      = "${path.module}/scripts/ec2_install"
    destination = "/tmp/"


    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ssh_username
      private_key = var.ssh_private_key
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i \"s|\\\"ssm_path_prefix\\\": \\\"/\\\"|\\\"ssm_path_prefix\\\": \\\"${var.ssm_path_prefix}\\\"|g\" /tmp/ec2_install/scripts/ssm.json",
      "sed -i \"s|\\\"release\\\": \\\"magento/project-community-edition\\\"|\\\"release\\\": \\\"${var.mage_composer_release}\\\"|g\" /tmp/ec2_install/scripts/magento-composer-config.json",
      "chmod +x /tmp/ec2_install/scripts/*.sh",
      "/tmp/ec2_install/scripts/install_stack.sh",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ssh_username
      private_key = var.ssh_private_key
    }
  }

  tags = {
    Name = local.instance_tag_name
  }
}

resource "random_pet" "ami" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    ami_id = aws_instance.magento_instance.id
  }
}

resource "aws_ami_from_instance" "magento_ami" {
  name               = "magento-ami-${random_pet.ami.id}"
  source_instance_id = aws_instance.magento_instance.id
  depends_on = [
    aws_instance.magento_instance
  ]
}

# This process can leave dangling resources, always run this destroy command every apply
resource "null_resource" "destroy_any_running_amis" {
  triggers = {
    always_run = "${timestamp()}"
  }

  depends_on = [
    aws_ami_from_instance.magento_ami
  ]

  provisioner "local-exec" {
    command = "${path.module}/scripts/local/cleanup-instances.sh"
    environment = {
      AWS_REGION        = var.region
      INSTANCE_TAG_NAME = local.instance_tag_name
    }
  }
}
