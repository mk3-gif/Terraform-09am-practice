terraform {
  backend "s3" {
    bucket = "terraform-dev-mk"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
