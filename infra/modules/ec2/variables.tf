variable "project_name" {
  description = "Nome do projeto para uso em tags"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "ID da subnet publica onde a EC2 sera lancada"
  type        = string
}

variable "security_group_id" {
  description = "ID do Security Group a ser associado a EC2"
  type        = string
}

variable "db_host" {
  description = "Endpoint do banco de dados RDS"
  type        = string
  default     = ""
}

variable "db_port" {
  description = "Porta do banco de dados"
  type        = string
  default     = "5432"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "reservas_db"
}

variable "db_user" {
  description = "Usuario do banco de dados"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
  default     = ""
}

variable "key_name" {
  description = "Nome do Key Pair para acesso SSH (opcional)"
  type        = string
  default     = null
}
