module "dev" {
    #source of module from directory day-7-module-source
    source = "../Day-7-modules-source"
    #variables define in day-7-module-source we assign value here
    ami_id="ami-08a6efd148b1f7504"
    instance_type = "t2.micro"
    name = "module-dev"
  
}
#now run the command terraform init terraform plan terraform apply -auto-approve