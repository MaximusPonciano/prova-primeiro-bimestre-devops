variable "project_name" {
  description = "Nome do projeto para uso em tags"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde os Security Groups serão criados"
  type        = string
}
