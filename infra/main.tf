# ---------------------------------------------------------
# Root Module: Orquestra todos os módulos da infraestrutura
# ---------------------------------------------------------

# 1. Rede (VPC, Subnets, IGW, NAT GW)
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}

# 2. Firewall (Security Groups EC2 + RDS)
module "security_group" {
  source       = "./modules/security-group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

# 3. Banco de Dados (RDS PostgreSQL na camada privada)
module "rds" {
  source            = "./modules/rds"
  project_name      = var.project_name
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.security_group.rds_sg_id
  db_password       = var.db_password
  db_username       = var.db_username
  db_name           = var.db_name
}

# 4. Servidor (EC2 na camada pública com Docker + API)
module "ec2" {
  source            = "./modules/ec2"
  project_name      = var.project_name
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_group.ec2_sg_id
  db_host           = module.rds.address
  db_port           = tostring(module.rds.port)
  db_name           = module.rds.db_name
  db_user           = var.db_username
  db_password       = var.db_password
  key_name          = var.key_name
}
