provider "aws" {
  region = "us-east-1" # Change if needed
}


# 1. VPC + Subnets

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "my-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "my-igw" }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-1" }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-2" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}


# 2. Security Groups

# For Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
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

# For EC2 Instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # Only ALB can reach EC2
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# 3. EC2 Instance

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1) - change region if needed
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public1.id
  security_groups = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
    #configure the installation script
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              echo "Hello from Terraform EC2 via ALB!" > /var/www/html/index.html
              EOF

  tags = { Name = "web-instance" }
}


# 4. Target Group

resource "aws_lb_target_group" "my_tg" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance" #ec2 instance

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Attach EC2 to Target Group
resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.my_tg.arn
  target_id        = aws_instance.web.id #instance id
  port             = 80
}


# 5. Load Balancer (ALB)

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false # Public ALB internet facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  enable_deletion_protection = false
  tags = { Name = "my-alb" }
}


# 6. Listener

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}


# 7. Outputs

output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}
