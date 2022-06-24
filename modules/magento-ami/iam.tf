# ------------------
# | IAM Policies   |
# ------------------

# Allow Magento hosts to fetch EC2 tags

resource "aws_iam_role" "magento_ami_host_role" {
  name               = "MagentoAMIHostRole"
  assume_role_policy = file("${path.module}/iam_policies/magento-ami-host-role.json")
}

resource "aws_iam_role_policy" "magento_ami_instance_role_policy" {
  name = "MagentoAMIHostPolicy"
  policy = templatefile("${path.module}/iam_policies/magento-ami-iam-policy.json",
    {
      "ssm_path_prefix" = var.ssm_path_prefix
  })
  role = aws_iam_role.magento_ami_host_role.id
}

resource "aws_iam_instance_profile" "magento_ami_host_profile" {
  name = "MagentoAMIHostProfile"
  role = aws_iam_role.magento_ami_host_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.magento_ami_host_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
