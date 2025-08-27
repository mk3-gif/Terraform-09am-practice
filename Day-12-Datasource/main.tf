provider "aws" {
    
}
data "aws_subnet" "name" {
    filter {
    name   = "tag:Name"
    values = ["dev"] # insert value here
  }
}
data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
             filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
        filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}
# data "aws_ami" "amzlinux" {
#   most_recent = true
#   owners = [ "self" ]
#   filter {
#     name = "name"
#     values = [ "frontend-ami" ]
#   }

# }
resource "aws_instance" "name" {
    ami=data.aws_ami.amzlinux.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.name.id

}

output "subnet_name" {
  value = data.aws_subnet.name.tags["Name"]
}

#👉 Rule of thumb: ID = .id | Name = .tags["Name"]

# Terraform Data Source

# A data source in Terraform lets you fetch/read information from existing resources without creating new ones.

# It acts like a lookup — useful when you need details (IDs, attributes, tags) of resources already created in AWS (or other providers).

# Data sources are read-only; they don’t modify infrastructure.

# Common examples in AWS:

# aws_vpc → fetch an existing VPC by tag or ID

# aws_subnet → get details of an existing subnet

# aws_ami → find the latest AMI by filters

# aws_security_group → lookup an SG by name
