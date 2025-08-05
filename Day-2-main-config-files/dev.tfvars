ami_id = "ami-08a6efd148b1f7504"
ec2="t2.micro"
# variables created now this variable act reference for variables.tf
#inside variables.tf call the values and ami_id and ec2 are name of variables block
# terraform apply -var-file="dev.tfvars"