module "ec2" {
    source="../Day-7-modules-source"
    ami_id="ami-08a6efd148b1f7504"
    instance_type = "t2.micro"
    name = "MK-dev"
  
}