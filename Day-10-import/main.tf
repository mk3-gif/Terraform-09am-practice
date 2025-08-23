resource "aws_instance" "name" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"

  tags = {
    Name="ec2-dev-mk"
  }
}

#terraform import aws_instance.name  i-08a403b30bfd57b78  change instance id that already exit 

resource "aws_s3_bucket" "bucket" {
  bucket = "mktestdev"
}
#terraform import aws_s3_bucket.name mktestdev  here change bucket name that already exist

resource "aws_iam_user" "mk" {
  name = "mk-dev"
}
#$ terraform import aws_iam_user.mk mk-dev