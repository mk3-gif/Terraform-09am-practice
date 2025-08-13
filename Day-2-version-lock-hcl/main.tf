resource "aws_instance" "name" {
  ami           = var.ami_id
  instance_type = var.ec2

  tags = {
    Name = "terraform"
  }
}
# now use variables.tf for holding values instead of harding code.
#"name" -> can be any name like dev or test etc 