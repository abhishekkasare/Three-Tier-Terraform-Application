
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name
  acl    = var.acl

  versioning {
    enabled = var.enable_versioning
  }

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  lifecycle {
    prevent_destroy = "false"
  }
}
