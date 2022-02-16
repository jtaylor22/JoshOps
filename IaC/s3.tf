resource "aws_s3_bucket" "jenkins_alb_log_bucket" {
  bucket = "jenkins_alb_log_bucket"

  tags = {
    Name        = "jenkins_alb_log_bucket"
  }
}

resource "aws_s3_bucket_acl" "jenkins_alb_log_bucket_acl" {
  bucket = aws_s3_bucket.jenkins_alb_log_bucket.id
  acl    = "private"
}