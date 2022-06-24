resource "aws_iam_role" "varnish_host_role" {
  name               = "${var.project}-VarnishHostRole"
  assume_role_policy = file("${path.module}/iam_policies/varnish-host-role.json")
}

resource "aws_iam_instance_profile" "varnish_host_profile" {
  name = "${var.project}-VarnishHostProfile"
  role = aws_iam_role.varnish_host_role.name
}

resource "aws_iam_role_policy_attachment" "varnish_ssm_managed_instance" {
  role       = aws_iam_role.varnish_host_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
