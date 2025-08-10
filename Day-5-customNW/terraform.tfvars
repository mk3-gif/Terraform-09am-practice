region               = "us-east-1"

vpc_cidr             = "10.0.0.0/16"
vpc_name             = "dev-vpc"

public_subnet_cidr   = "10.0.0.0/24"
private_subnet_cidr  = "10.0.1.0/24"

public_subnet_name   = "dev-public-subnet"
private_subnet_name  = "dev-private-subnet"

igw_name             = "dev-igw"
public_rt_name       = "dev-public-rt"
private_rt_name      = "dev-private-rt"

nat_eip_name         = "dev-nat-eip"
nat_gw_name          = "dev-nat-gw"

sg_name              = "allow_tls"
sg_tag_name          = "dev-sg"

public_ec2_ami       = "ami-0de716d6197524dd9" # Amazon Linux 2
private_ec2_ami      = "ami-08a6efd148b1f7504" # Amazon Linux 2

instance_type        = "t2.micro"
key_name             = "my-keypair"

public_ec2_name      = "dev-public-ec2"
private_ec2_name     = "dev-private-ec2"
