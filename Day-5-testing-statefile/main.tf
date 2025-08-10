resource "aws_s3_bucket" "name" {
  bucket = "testday5mk"
}

/*
test result:
$ terraform init
Terraform has been successfully initialized!

terraform plan
when --
key="day-5/terraform.tfstate"

Plan: 1 to add, 0 to change, 0 to destroy.
(only 1 new resource s3 bucket creating)

terraform plan
when
key ="day-4/terraform.tfstate"
Plan: 1 to add, 0 to change, 2 to destroy.
(ec2 and vpc exists thats why 2 to destroy . and 1 new s3 bucket creating)



*/