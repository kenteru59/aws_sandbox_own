provider "aws" {
  # リージョンは東京にしよう
  region = "ap-northeast-1"
}

# TerraformのstateファイルをS3に保存
terraform {
  backend "s3" {
    key            = "envs/sandbox/terraform.tfstate"
    bucket         = "sandbox-terraform-state-20250414"
    region         = "ap-northeast-1"
    dynamodb_table = "sandbox-terraform-state-lock"
    encrypt        = true
  }
}
