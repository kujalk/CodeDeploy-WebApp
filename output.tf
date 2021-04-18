
output "Prod-EC2-IP" {
  value = aws_instance.Prod.public_ip
}