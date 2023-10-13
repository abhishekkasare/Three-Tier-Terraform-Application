
variable "region" {
  description = "The AWS region where the S3 bucket should be created."
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
}

variable "acl" {
  description = "The access control list for the S3 bucket."
}

variable "enable_versioning" {
  description = "Set to true to enable versioning for the bucket."
}

variable "index_document" {
  description = "The default index document for the S3 bucket."
}

variable "error_document" {
  description = "The error document for the S3 bucket."
}
