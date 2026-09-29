#!/bin/bash
set -euo pipefail

# ---------------------------------------------------------
# UserData: Provisiona Docker e sobe a API de Reservas
# Roda diretamente via docker run (sem compose) para evitar
# conflito com depends_on do servico db local.
# ---------------------------------------------------------

exec > /var/log/userdata.log 2>&1
set -x

# 1. Atualiza pacotes e instala Docker
apt-get update -y
apt-get install -y docker.io git

# 2. Habilita e inicia o Docker
systemctl enable docker
systemctl start docker

# 3. Clona o repositorio da API na branch ativa
cd /home/ubuntu
git clone -b infra/setup-aws-terraform https://github.com/MaximusPonciano/prova-primeiro-bimestre-devops.git app || git clone https://github.com/MaximusPonciano/prova-primeiro-bimestre-devops.git app
cd app/app

# 4. Build da imagem Docker da API
docker build -t reservas-api .

# 5. Roda o container apontando diretamente ao RDS
docker run -d \
  --name reservas-api \
  --restart unless-stopped \
  -p 3000:3000 \
  -e DB_HOST=${db_host} \
  -e DB_PORT=${db_port} \
  -e DB_NAME=${db_name} \
  -e DB_USER=${db_user} \
  -e DB_PASS=${db_password} \
  -e DATABASE_URL=postgres://${db_user}:${db_password}@${db_host}:${db_port}/${db_name} \
  -e PORT=3000 \
  reservas-api
