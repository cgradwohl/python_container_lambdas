terraform {
  backend "s3" {
    bucket = var.state_bucket_name
    key    = "path/to/my/key"
    region = var.aws_region
  }
}
