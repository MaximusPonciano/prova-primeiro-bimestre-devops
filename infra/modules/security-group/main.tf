# ---------------------------------------------------------
# Security Group da EC2 (Camada Pública — Web)
# ---------------------------------------------------------
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "Permite SSH (22) e API (80) de qualquer origem"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API Node.js (HTTP)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Permite todo trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# ---------------------------------------------------------
# Security Group do RDS (Camada Privada — Dados)
# Aceita conexoes APENAS do SG da EC2 (Principio de Menor Privilegio)
# ---------------------------------------------------------
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Permite PostgreSQL (5432) somente do SG da EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL vindo da EC2"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    description = "Permite todo trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}
