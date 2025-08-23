variable "allowed_ports" {
  type = map(string)
#   type = map(string) → The variable is a map (key-value pairs), where keys are port numbers, 
# and values are CIDR ranges (IP address ranges).
  default = {
    # Provides default port-to-CIDR mapping:
    22    = "203.0.113.0/24"    # SSH (Restrict to office IP)
    80    = "0.0.0.0/0"         # HTTP (Public)
    443   = "0.0.0.0/0"         # HTTPS (Public)
    8080  = "10.0.0.0/16"       # Internal App (Restrict to VPC)
    9000  = "192.168.1.0/24"    # SonarQube/Jenkins (Restrict to VPN)
    3389  = "10.0.1.0/24"
    3306  = "192.168.1.2/32"
  }
}

resource "aws_security_group" "custom_SG" {
  name        = "custom_SG"
  description = "Allow restricted inbound traffic"

# dynamic "ingress" → Used to loop through multiple rules instead of writing them manually.
  dynamic "ingress" {
    # Iterates over the allowed_ports map:
    for_each = var.allowed_ports
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = [ingress.value] #cidr_blocks = [ingress.value] → Allows traffic only from the specified IP/CIDR.
    }
     
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "custom_SG"
  }
}