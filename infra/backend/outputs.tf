output "s3_bucket_name" {
  description = "Nome do bucket S3 criado para o state remoto"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB criada para o state lock"
  value       = aws_dynamodb_table.terraform_locks.name
}
