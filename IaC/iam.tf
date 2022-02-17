resource "aws_iam_instance_profile" "jenkins_slave_instance_profile" {
  name = "jenkins_slave_instance_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "jenkins_slave_role" {
  name               = "jenkins_slave_instance_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}


data "aws_iam_policy_document" "jenkins_slave_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "jenkins_slave_policy" {
  role       = aws_iam_role.jenkins_slave_role.name
  policy_arn = aws_iam_policy_document.jenkins_slave_policy_document.json
}

data "aws_iam_policy_document" "jenkins_slave_policy_document" {
  statement {
    actions   = ["s3:*"]
    resources = ["*"]
  }
  statement {
    actions   = ["ec2:CreateImage"]
    resources = ["arn:aws:ec2:*::snapshot/*", "arn:aws:ec2:*::image/*", "arn:aws:ec2:*:734522818672:instance/*"]
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_slave_policy_attachment" {
  role       = aws_iam_role.jenkins_slave_role.name
  policy_arn = aws_iam_policy.jenkins_slave_policy.arn
}
