variable "ami" {
  type    = string
  default = "ami-08a6efd148b1f7504"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "env" {
  type    = list(string)
  default = ["dev","test","prod"]
  #remove test.
}

resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = toset(var.env) #toset () to convert list to set
#   count = length(var.env)  if it is count 

  tags = {
    Name = each.value # for a set, each.value and each.key is the same
  }
}


# 🔹 Why use toset() here?

# for_each in Terraform requires either:

# a map ({key = value, ...}), or

# a set of strings (toset(["one","three"]))

# Since your variable env is a list, you must convert it into a set for for_each to work.

# 🔹 Difference between list and set

# List → ordered collection, allows duplicates.
# Example: ["one", "one", "three"] (duplicates allowed).

# Set → unordered collection, no duplicates.
# Example: toset(["one", "one", "three"]) → becomes ["one", "three"] (duplicates removed).



# 🔹 Example with a Map
# variable "env" {
#   type = map(string)
#   default = {
#     one   = "dev"
#     three = "prod"
#   }
# }

# resource "aws_instance" "sandbox" {
#   ami           = var.ami
#   instance_type = var.instance_type
#   for_each      = var.env

#   tags = {
#     Name = each.key     # => "one" or "three"
#     Env  = each.value   # => "dev" or "prod"
#   }
# }

# 🔹 What happens here?

# Terraform will create:

# aws_instance.sandbox["one"]

# Tag Name = one

# Tag Env = dev

# aws_instance.sandbox["three"]

# Tag Name = three

# Tag Env = prod

# 🔹 Difference: set vs map

# Set → only a list of values (no key → value pairs).

# toset(["one","three"])


# → each.key = "one", each.value = "one" (same thing).

# Map → has key → value relationship.

# {
#   one   = "dev"
#   three = "prod"
# }


# → each.key = "one", each.value = "dev".

# So with a map, you can attach metadata easily (like environment, team, owner, etc.) instead of just names.