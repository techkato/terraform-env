variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "aws_profile" {
  type    = string
  default = "terraform_user"
}

variable "s3_bucket_name" {
  type    = string
  default = "techkato-s3"
}

variable "dynamodb_name" {
  type    = string
  default = "tfstate-lock"
}