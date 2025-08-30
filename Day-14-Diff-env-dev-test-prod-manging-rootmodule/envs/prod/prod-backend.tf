
terraform {
  backend "s3" {
    bucket         = "nareshitmkdevops"
    key            = "prod/terraform.tfstate" #inside prod directory
    region         = "us-east-1"
    use_lockfile = true
  }
}
