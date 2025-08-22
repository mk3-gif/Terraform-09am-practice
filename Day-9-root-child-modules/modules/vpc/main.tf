resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
  availability_zone = var.az
  
}
#print to use inside main.tf
# output = A block that makes Terraform print a value after apply and also expose it to other modules.

# "subnet_id" = The name of the output (you’ll reference it as module.vpc.subnet_id).
output "subnet_id" {
  value = aws_subnet.main.id
}