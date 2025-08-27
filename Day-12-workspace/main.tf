provider "aws" {
  
}


resource "aws_instance" "name" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.micro"
    #key_name = "test"
  
}

# $ terraform workspace
# Usage: terraform [global options] workspace

#   new, list, show, select and delete Terraform workspaces.

# Subcommands:
#     delete    Delete a workspace
#     list      List Workspaces
#     new       Create a new workspace
#     select    Select a workspace
#     show      Show the name of the current workspace


# Subcommand	Purpose
# new	Create a new workspace. Example: terraform workspace new dev
# list	Show all existing workspaces. Example: terraform workspace list
# show	Show the current workspace you’re in. Example: terraform workspace show
# select	Switch to a different workspace. Example: terraform workspace select dev
# delete	Delete a workspace (cannot delete the current one). Example: terraform workspace delete dev

#terraform workspace show

# $ terraform workspace show
# test

# $ terraform workspace new prod
# Created and switched to workspace "prod"!

# $ terraform workspace select dev
# Switched to workspace "dev".
#terraform workspace select default
#terraform workspace show

# terraform.tfstate.d -- > contains list of workspace
