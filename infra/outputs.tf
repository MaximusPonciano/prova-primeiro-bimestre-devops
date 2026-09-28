output "ec2_public_ip" {
  description = "IP publico da instancia EC2"
  value       = module.ec2.public_ip
}

output "api_url" {
  description = "URL da API de Reservas"
  value       = module.ec2.api_url
}

output "rds_endpoint" {
  description = "Endpoint de conexao do RDS (host:porta)"
  value       = module.rds.endpoint
  sensitive   = true
}

output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}
