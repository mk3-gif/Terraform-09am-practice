resource "aws_instance" "dev" {
    ami=var.ami_id
    instance_type=var.instance_type
    tags = {
        Name = var.name
    }
}
#now call inside Day-7-module-calling-ex2