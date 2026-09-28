output "endpoint" {
  description = "Endpoint de conexao do RDS (host:porta)"
  value       = aws_db_instance.main.endpoint
}

output "address" {
  description = "Hostname do RDS (sem porta)"
  value       = aws_db_instance.main.address
}

output "port" {
  description = "Porta do RDS"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Nome do banco de dados criado"
  value       = aws_db_instance.main.db_name
}
