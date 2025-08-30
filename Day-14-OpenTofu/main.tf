resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
  
}

resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
  
}
## added for testing for opentofu
resource "aws_s3_bucket" "name" {
    bucket = "mkdevopsveryscdte"
  
}

# test out the instance with opentofu
resource "aws_instance" "name" {
    
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.micro"
  tags = {
    Name = "tofu-ec2"
  }
}