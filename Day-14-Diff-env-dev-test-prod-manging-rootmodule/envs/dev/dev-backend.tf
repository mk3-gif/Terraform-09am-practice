
terraform {
  backend "s3" {
    bucket         = "nareshitmkdevops"
    key            = "dev/terraform.tfstate" #inside dev directory
    region         = "us-east-1"
    use_lockfile = true
    
  }
}
