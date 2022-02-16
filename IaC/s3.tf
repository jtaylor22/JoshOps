resource "aws_s3_bucket" "jenkins_alb_log_bucket" {
  bucket = "jenkins-alb-log-bucket"

  tags = {
    Name = "jenkins-alb-log-bucket"
  }
}

# resource "aws_s3_bucket_acl" "jenkins_alb_log_bucket_acl" {
#   bucket = aws_s3_bucket.jenkins_alb_log_bucket.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_policy" "allow_access_from_alb" {
#   bucket = aws_s3_bucket.jenkins_alb_log_bucket.id
#   policy = data.aws_iam_policy_document.allow_access_from_alb_document.json
# }

# data "aws_iam_policy_document" "allow_access_from_alb_document" {
#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = [data.aws_caller_identity.current.account_id]
#     }

#     actions = [
#       "s3:PutObject",
#       "s3:GetBucketAcl"
#     ]

#     resources = [
#       "${aws_s3_bucket.jenkins_alb_log_bucket.arn}/*",
#     ]
#   }
# }