provider "aws" {
  region = "us-east-1"
  profile = "prod"
 
  
}

provider "aws" {
  region = "us-west-2"
  alias = "dev"
  profile = "prod"
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    provider = aws.dev
  
}

resource "aws_s3_bucket" "name" {
    bucket = "tdcsgddhsvdsh"
  
}

#note we can use multi provider block if diff requirement and diff resource and diff regions

#if alias not user then error or comment out alias in provider error: Error: Duplicate provider configuration 

#profile = "prod" comment out otherwise error:Planning failed. Terraform encountered an error while generating this plan.

╷
# │ Error: failed to get shared config profile, prod
# │
# │   with provider["registry.terraform.io/hashicorp/aws"],
# │   on main.tf line 1, in provider "aws":
# │    1: provider "aws" {
# │
# ╵
# ╷
# │ Error: failed to get shared config profile, prod
# │
# │   with provider["registry.terraform.io/hashicorp/aws"].dev,
# │   on main.tf line 8, in provider "aws":
# │    8: provider "aws" {
# │