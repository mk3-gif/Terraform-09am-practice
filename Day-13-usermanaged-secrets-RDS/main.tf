# main.tf
provider "aws" {
  region = "us-east-1"
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = "dbsecrets" #fetch the secret
}

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
}

# vpc.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

# security.tf
resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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

# rds.tf
resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  identifier             = "my-rds-db"
  db_name                 = "mydb"
  username               = local.rds_credentials.username
  password               = local.rds_credentials.password
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
}

# outputs.tf
output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}


/*---
🔹 Flow to create Secrets Manager secret for RDS

Go to AWS Console → Secrets Manager

Click Store a new secret.

Select secret type

Choose Other type of secret (since we’re not using "RDS database credentials" type, but custom).

Add key/value pairs
Example:

Key       | Value
----------|---------
username  | admin
password  | MyStrongP@ssw0rd


(These keys must match what you reference in Terraform → local.rds_credentials.username and .password)

Secret name

Enter: dbsecrets (must match your Terraform secret_id)

Encryption key

Use default AWS-managed key (fine for most cases).

Finish

Click through next steps and create secret.

🔹 How Terraform uses it

Terraform fetches the latest version of that secret:

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = "dbsecrets"
}


Terraform parses the secret into local variables:

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
}


Then passes them to RDS:

username = local.rds_credentials.username
password = local.rds_credentials.password


So Terraform never stores the password in plain text—✅ good security practice.

🔹 Simple Flow Diagram
AWS Secrets Manager
    (dbsecrets)
     └── key/value
         ├─ username = admin
         └─ password = MyStrongP@ssw0rd
               │
               ▼
Terraform ──► data.aws_secretsmanager_secret_version.rds
               │
               ▼
          locals.rds_credentials
               │
               ▼
      aws_db_instance.mysql

      ---*/