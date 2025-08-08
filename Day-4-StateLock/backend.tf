terraform {
  backend "s3" {
    bucket = "s3bucketstatefilemk"
    key    = "day-4/terraform.tfstate"
    region = "us-east-1"
  
    encrypt = true
  }
}