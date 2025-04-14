provider "aws" {
  # リージョンは東京にしよう
  region = "ap-northeast-1"
}

# state管理用のS3バケットを作成する
resource "aws_s3_bucket" "sandbox_terraform_state" {
  bucket = "sandbox-terraform-state-20250414"

  # 間違ってバケットを削除しないようにしておこう
  lifecycle {
    prevent_destroy = true # 本当に消すときはfalseにする
  }
}

# S3バケットのバージョニングを有効にしておこう
resource "aws_s3_bucket_versioning" "sandbox_terraform_state_ver" {
  bucket = aws_s3_bucket.sandbox_terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 明示的にパブリックアクセスを禁止にしておこう
resource "aws_s3_bucket_public_access_block" "sandbox_terraform_state_block" {
  bucket                  = aws_s3_bucket.sandbox_terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# stateをロックするためのDynamoDBテーブルを作ろう
resource "aws_dynamodb_table" "sandbox_terraform_state_lock" {
  name         = "sandbox-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# TerraformのstateファイルをS3に保存
terraform {
  backend "s3" {
    key            = "state/s3/terraform.tfstate"
    bucket         = "sandbox-terraform-state-20250414"
    region         = "ap-northeast-1"
    dynamodb_table = "sandbox-terraform-state-lock"
    encrypt        = true
  }
}
