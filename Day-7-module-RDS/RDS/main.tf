# 1. Creation of Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.subnet_group
  subnet_ids = [
    var.subnet_id_1,
    var.subnet_id_2
  ]
  tags = {
    Name = var.subnet_group_tag
  }
}

# 2. Security Group
resource "aws_security_group" "rds_sg" {
  name        = var.sg_name
  description = "Security group for RDS"
  vpc_id      = var.sg_vpc_id

  ingress {
    from_port   = var.ingress_port
    to_port     = var.ingress_port
    protocol    = var.ingress_protocol
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = var.egress_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.rds_sg_tags
  }
}

# 3. Creation of RDS Instance
resource "aws_db_instance" "rds" {
  engine                  = "mysql"
  engine_version          = "8.0"
  db_name                 = var.rds_db_name
  identifier              = var.rds_db_name
  username                = var.rds_db_usrname
  password                = var.rds_db_password
  instance_class          = var.rds_instance_class
  storage_type            = "gp2"
  allocated_storage       = 20
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = var.rds_backup_retention_period

  tags = {
    Name = var.rds_tags
  }
}
