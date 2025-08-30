
terraform {
  backend "s3" {
    bucket         = "nareshitmkdevops"
    key            = "test/terraform.tfstate" #inside test directory
    region         = "us-east-1"
    use_lockfile = true
  }
}
