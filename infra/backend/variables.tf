variable "aws_region" {
  description = "A região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "O nome globalmente único do bucket S3 para o estado do Terraform"
  type        = string
  default     = "tech-nova-tf-state-devops-2026-maximus"
}

variable "dynamodb_table_name" {
  description = "O nome da tabela do DynamoDB para o state locking"
  type        = string
  default     = "tech-nova-terraform-state-locks"
}
