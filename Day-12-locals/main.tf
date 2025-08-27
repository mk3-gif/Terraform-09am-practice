locals {
  region        = "us-east-1"
  ami           = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
}

resource "aws_instance" "example" {
  ami           = local.ami
  instance_type = local.instance_type
  tags = {
    Name = "App-${local.region}"
  }
}

# In Terraform, a locals block is used to define local values—essentially variables that exist only within the module or configuration file and are not meant to be passed in from outside. They are useful for avoiding repetition and making your code cleaner.

# Syntax:
# locals {
#   name_prefix = "dev"
#   environment = "staging"
#   full_name   = "${local.name_prefix}-app"
# }

# Key Points:

# Accessing local values:

# resource "aws_instance" "example" {
#   name = local.full_name
#   # other arguments
# }


# Expressions are allowed:
# You can do concatenation, arithmetic, conditionals, lists, maps, etc.

# Scope:

# Local values are module-scoped.

# They cannot be accessed outside the module where they are defined.

# Advantages:

# Avoids repeating the same value in multiple places.

# Makes the configuration easier to maintain.

# Can compute values dynamically.

# Example with list and map:
# locals {
#   regions = ["us-east-1", "us-west-2"]
#   ami_map = {
#     us-east-1 = "ami-12345"
#     us-west-2 = "ami-67890"
#   }
# }

# output "first_region" {
#   value = local.regions[0]
# }

# output "ami_for_east" {
#   value = local.ami_map["us-east-1"]
# }


# ✅ Local values are read-only, so you cannot change them after definition