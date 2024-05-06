terraform {
  backend "s3" {
    bucket = "dev-tfstate-bucket-cgx31dmm"
    key    = "path/to/my/key"
    region = var.aws_region
  }
}
