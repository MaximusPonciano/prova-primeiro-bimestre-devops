# ---------------------------------------------------------
# AMI mais recente do Ubuntu 22.04 LTS (us-east-1)
# ---------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ---------------------------------------------------------
# EC2 — Servidor da API (Camada Pública)
# ---------------------------------------------------------
resource "aws_instance" "api" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = "LabInstanceProfile"
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
    db_host     = var.db_host
    db_port     = var.db_port
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
  }))

  tags = {
    Name = "${var.project_name}-api-server"
  }
}
