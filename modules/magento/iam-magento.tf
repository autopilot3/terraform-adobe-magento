resource "aws_iam_role" "magento_host_role" {
  name               = "MagentoHostRole"
  assume_role_policy = file("${path.module}/iam_policies/magento-host-role.json")
}

resource "aws_iam_role_policy" "magento_instance_role_policy" {
  name = "MagentoHostPolicy"
  policy = templatefile("${path.module}/iam_policies/magento-iam-policy.json",
    {
      "project"         = var.project,
      "bucket"          = aws_s3_bucket.magento_files.bucket,
      "ssm_path_prefix" = var.ssm_path_prefix
  })
  role = aws_iam_role.magento_host_role.id
}

resource "aws_iam_instance_profile" "magento_host_profile" {
  name = "MagentoHostProfile"
  role = aws_iam_role.magento_host_role.name
}

resource "aws_iam_role_policy_attachment" "magento_ssm_managed_instance" {
  role       = aws_iam_role.magento_host_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
