variable "subnet_group" {
    description = "database subnet group"
    type = string
    default = null
  
}
variable "subnet_id_1" {
    description = "subnet1 id"
    type = string
    default = null
  
}
variable "subnet_id_2" {
  description = "subnet2 id"
  type = string
  default = null
}

variable "subnet_group_tag" {
    description = "database subnet group tag"
    type = string
    default = null
  
}

variable "sg_name" {
    description = "security group name"
    type = string
    default = null
  
}
variable "sg_vpc_id" {
    description = "security group vpc id"
    type = string
    default = null
  
}
variable "ingress_port" {
    description = "mysql port 3306"
    type = number
    default = null
  
}

variable "ingress_protocol" {
    description = "tcp"
    type = string
    default = null
  
}

variable "ingress_cidr_blocks" {
    description = "0.0.0.0/0"
    type = list(string)
    default = null
  
}

variable "egress_port" {
    description = "all ports"
    type = number
    default = null
  
}
variable "egress_protocol" {
    description = "wildcard protocols"
    type = string
    default = null
  
}

variable "rds_sg_tags" {
    description = "rds sg tags"
    type = string
    default = null
  
}

variable "rds_db_name" {
    description = "database name"
    type = string
    default = null
  
}
variable "rds_db_usrname" {
    description = "database username"
    type = string
    default = null
  
}

variable "rds_db_password" {
    description = "database password"
    type = string
    default = null
  
}
variable "rds_instance_class" {
    description = "database instance class"
    type = string
    default = null
  
}
variable "rds_backup_retention_period" {
    description = "database backup retention period"
    type = number
    default = null
  
}

variable "rds_tags" {
    description = "database tags"
    type = string
    default = null
  
}