resource "aws_s3_bucket" "jenkins_alb_log_bucket" {
  bucket = "jenkins-alb-log-bucket"

  tags = {
    Name        = "jenkins-alb-log-bucket"
  }
}

resource "aws_s3_bucket_acl" "jenkins_alb_log_bucket_acl" {
  bucket = aws_s3_bucket.jenkins_alb_log_bucket.id
  acl    = "private"
}