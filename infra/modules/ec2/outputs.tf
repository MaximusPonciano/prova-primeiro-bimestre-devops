output "instance_id" {
  description = "ID da instancia EC2"
  value       = aws_instance.api.id
}

output "public_ip" {
  description = "IP publico da EC2"
  value       = aws_instance.api.public_ip
}

output "api_url" {
  description = "URL da API de Reservas"
  value       = "http://${aws_instance.api.public_ip}"
}
