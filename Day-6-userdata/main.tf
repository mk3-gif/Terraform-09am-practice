
provider "aws" {
  
}

resource "aws_instance" "name" {
    ami = "ami-0de716d6197524dd9"
    instance_type = "t2.micro"
    availability_zone = "us-east-1c"
    associate_public_ip_address = true
    user_data = file("test.sh")
    tags = {
        Name = "devtest"
    }

}