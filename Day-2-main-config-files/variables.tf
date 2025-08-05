variable "ami_id" {
      
    description = "ami id"
    type = string 
    default =""# get the variable form terraform.tfvars , ami_id
}

variable "ec2" {
    description = "ec2 type"
    type = string
    default = ""# get the variable form terraform.tfvars, ec2
  
}