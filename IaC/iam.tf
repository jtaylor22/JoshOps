resource "aws_iam_instance_profile" "jenkins_slave_instance_profile" {
  name = "jenkins_slave_instance_profile"
  role = aws_iam_role.jenkins_slave_role.name
}

resource "aws_iam_role" "jenkins_slave_role" {
  name               = "jenkins_slave_instance_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.jenkins_slave_assume_role_policy.json
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
  name   = "jenkins_slave_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.jenkins_slave_policy_document.json
}

data "aws_iam_policy_document" "jenkins_slave_policy_document" {
  statement {
    actions   = ["s3:*"]
    resources = ["*"]
  }
  statement {
    actions   = ["ec2:CreateImage", "ec2:DescribeImages", "ec2:DescribeInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_slave_policy_attachment" {
  role       = aws_iam_role.jenkins_slave_role.name
  policy_arn = aws_iam_policy.jenkins_slave_policy.arn
}
