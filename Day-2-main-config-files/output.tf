output "public_ip" {
    value = aws_instance.name.public_ip # main.tf block "aws_instance" "name" 
  
}
output "private_ip" {
    value = aws_instance.name.private_ip
  
}