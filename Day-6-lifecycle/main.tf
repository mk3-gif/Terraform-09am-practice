resource "aws_instance" "name" {
    ami = "ami-0de716d6197524dd9"
    instance_type = "t2.micro"
    availability_zone = "us-east-1c"
    tags = {
        Name = "dev"
    }

    lifecycle {
      #prevent_destroy = true
      #create_before_destroy = true
      #ignore_changes = [ tags,]

    }
    
  
}
