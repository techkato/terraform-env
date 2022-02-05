# S3
resource "aws_s3_bucket" "terraform-state" {
  bucket = var.s3_bucket_name

  # terraform destroyによって削除されないように指定
  lifecycle {
    prevent_destroy = true
  }

  # AES256でファイルを暗号化
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # バージョニングを設定
  versioning {
    enabled = true
  }

  tags = {
    Terraform = "true"
    Name      = "terraform"
  }
}

# S3 パブリックアクセスをブロック
resource "aws_s3_bucket_public_access_block" "terraform-state" {
  bucket                  = aws_s3_bucket.terraform-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB
resource "aws_dynamodb_table" "terraform-and-rails-state-lock" {
  name         = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # ロック目的で使用する場合、"LockID"とする必要がある

  attribute {
    name = "LockID" # ロック目的で使用する場合、"LockID"とする必要がある
    type = "S"
  }

  tags = {
    Terraform = "true"
    Name      = "terraform"
  }
}