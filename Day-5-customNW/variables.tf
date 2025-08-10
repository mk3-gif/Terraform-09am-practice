variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
  type        = string
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
}

variable "public_rt_name" {
  description = "Name of the public route table"
  type        = string
}

variable "private_rt_name" {
  description = "Name of the private route table"
  type        = string
}

variable "nat_eip_name" {
  description = "Name of the NAT EIP"
  type        = string
}

variable "nat_gw_name" {
  description = "Name of the NAT Gateway"
  type        = string
}

variable "sg_name" {
  description = "Security Group name"
  type        = string
}

variable "sg_tag_name" {
  description = "Security Group tag name"
  type        = string
}

variable "public_ec2_ami" {
  description = "AMI ID for public EC2"
  type        = string
}

variable "private_ec2_ami" {
  description = "AMI ID for private EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

variable "public_ec2_name" {
  description = "Tag name for public EC2 instance"
  type        = string
}

variable "private_ec2_name" {
  description = "Tag name for private EC2 instance"
  type        = string
}
