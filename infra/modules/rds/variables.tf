variable "project_name" {
  description = "Nome do projeto para uso em tags"
  type        = string
}

variable "subnet_ids" {
  description = "IDs das subnets privadas para o DB Subnet Group"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID do Security Group do RDS"
  type        = string
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "reservas_db"
}

variable "db_username" {
  description = "Usuario master do banco"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha master do banco"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Classe da instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "Versao do PostgreSQL"
  type        = string
  default     = "15"
}
