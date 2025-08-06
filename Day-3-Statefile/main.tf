# resource "aws_instance" "name" {
#   ami           = "ami-08a6efd148b1f7504"
#   instance_type ="t2.micro"

#   tags = {
#     Name = "terraformdev"
#   }
# }

resource "aws_instance" "ec2" {
  ami                    = "ami-08a6efd148b1f7504"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3_profile.name

  tags = {
    Name = "ec2-with-s3-access"
  }
}

