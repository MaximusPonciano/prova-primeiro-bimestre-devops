variable "project_name" {
  description = "Nome do projeto para uso em tags e nomes de recursos"
  type        = string
  default     = "technova"
}

variable "db_name" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "reservas_db"
}

variable "db_username" {
  description = "Usuario master do RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha master do RDS (nunca commitar — usar -var ou terraform.tfvars)"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "Nome do Key Pair AWS para acesso SSH a EC2 (opcional)"
  type        = string
  default     = null
}
