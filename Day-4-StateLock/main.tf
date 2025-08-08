resource "aws_instance" "ec2" {
  ami                    = "ami-08a6efd148b1f7504"
  instance_type          = "t2.micro"

  tags = {
    Name = "terrafrom_dev-1"
  }
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "devnew"
    }
  
}
