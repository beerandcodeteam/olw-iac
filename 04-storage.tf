resource "aws_s3_bucket" "olw_bucket" {
  bucket = "olw-s3-file-storage"

  tags = {
    Name = "olw_bucket"
    Project = "olw"
  }
}

resource "aws_s3_bucket_acl" "olw_bucket_acl" {
  bucket = aws_s3_bucket.olw_bucket.id
  acl    = "private"
}