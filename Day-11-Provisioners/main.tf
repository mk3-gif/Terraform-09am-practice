provider "aws" {
  region = "us-east-1"
}

# Key Pair
resource "aws_key_pair" "example" {
  key_name   = "task"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}
# Subnet
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  #all new EC2 instances in that subnet automatically get a public IP (unless you explicitly disable it in the instance block).

  tags = {
    Name = "PublicSubnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "igw" {
    #Internet Gateway (IGW) and attaches it to your VPC.
  vpc_id = aws_vpc.myvpc.id
}
# Route Table
resource "aws_route_table" "RT" {
    #Allow Internet access via IGW
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
# Route Table Subnet Associations
resource "aws_route_table_association" "rta1" {
    #VPC → Subnets → Select subnet → Route Table → Edit Route Table Association → Pick a route table.
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}
# Security Group
# AWS Console → EC2 → Security Groups → Create Security Group → Add Inbound/Outbound rules.
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance (Ubuntu)
resource "aws_instance" "server" {
  ami                         = "ami-0360c520857e3138f" # Ubuntu AMI
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.example.key_name
  subnet_id                   = aws_subnet.sub1.id
  vpc_security_group_ids      = [aws_security_group.webSg.id]
  associate_public_ip_address = true

  tags = {
    Name = "UbuntuServer"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"                          # ✅ Correct for Ubuntu AMIs
    private_key = file("~/.ssh/id_ed25519")             # Path to private key
    host        = self.public_ip                       # Connect using instance's public IP
    #host argument tells Terraform which IP/hostname it should use to connect (for provisioners like remote-exec or file).
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "file10"
    destination = "/home/ubuntu/file10"

# Copies a local file (file10 in your Terraform working directory) → into the remote server at /home/ubuntu/file10.

# So after apply, inside your EC2 instance, you’ll see file10 copied.
  }

#   provisioner "remote-exec" {  #server inside 
#     inline = [
#       "touch /home/ubuntu/file200",
#       "echo 'hello from AWS devops' >> /home/ubuntu/file200"
#     #   Runs commands inside the remote server (EC2).

#     #   Creates a file /home/ubuntu/file200
      
#     #   Writes hello from devops into it

#     #   This happens over SSH (using your connection {} block).
#     ]
#   }
#    provisioner "local-exec" {  # where terraform is running inside the directory 
#     command = "touch file500" 
#     # Runs locally on your Terraform machine (your laptop/VM where terraform apply is running).

#     # It will create a file500 inside the same folder where Terraform is executed, not on the server.
   
#  }
 }
 #without destroy and recrating the resource , we make the null resource to track the changes
resource "null_resource" "run_script" {
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.server.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
    }

    inline = [
      "echo 'hello from multicloud DEVOPS ' >> /home/ubuntu/file200"
    ]
  }

  triggers = {
    always_run = "${timestamp()}" # Forces rerun every time
  }
}


#Solution-2 to Re-Run the Provisioner
#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply

# 💡 Pro tip: In newer Terraform versions, terraform taint is deprecated. Instead you can just do:

# terraform apply -replace="aws_instance.server"

#terraform untaint aws_instance.server

# 🔹 What is null_resource?

# It’s a dummy resource that doesn’t create any infrastructure in AWS.

# You can attach provisioners (remote-exec, local-exec, file) to it.

# It uses triggers to decide when to re-run.

# Super useful for "run script on existing server" type of tasks.

# ✅ Here’s what’s happening:

# No EC2 recreation needed — your aws_instance.server stays untouched.

# The null_resource connects to the EC2 via SSH.

# Runs the command (echo 'hello from multicloud' >> /home/ubuntu/file200).

# triggers with ${timestamp()} ensures every terraform apply will re-run the script.

# 🔹 When to use it

# If you want to run scripts repeatedly on an existing server.

# If your provisioner logic should run independent of the EC2 lifecycle.

# Instead of terraform taint or -replace, which destroy/recreate the instance.

