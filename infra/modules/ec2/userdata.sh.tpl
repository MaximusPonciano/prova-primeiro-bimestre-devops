#!/bin/bash
exec > /var/log/userdata.log 2>&1
set -x

# Aguarda a trava do dpkg/apt ser liberada pelo unattended-upgrades do Ubuntu
echo "Aguardando instalacoes de boot do sistema..."
while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
   sleep 2
done

# 1. Atualiza pacotes e instala Docker + Git
apt-get update -y || true
apt-get install -y docker.io git

# 2. Habilita e inicia o serviço Docker
systemctl enable docker
systemctl start docker

# 3. Clona o repositorio da API na branch ativa
rm -rf /home/ubuntu/app
git clone -b infra/setup-aws-terraform https://github.com/MaximusPonciano/prova-primeiro-bimestre-devops.git /home/ubuntu/app || git clone https://github.com/MaximusPonciano/prova-primeiro-bimestre-devops.git /home/ubuntu/app

cd /home/ubuntu/app/app

# 4. Build da imagem Docker da API
docker build -t reservas-api .

# 5. Roda o container apontando diretamente ao RDS
docker rm -f reservas-api || true
docker run -d \
  --name reservas-api \
  --restart unless-stopped \
  -p 3000:3000 \
  -e DB_HOST="${db_host}" \
  -e DB_PORT="${db_port}" \
  -e DB_NAME="${db_name}" \
  -e DB_USER="${db_user}" \
  -e DB_PASS="${db_password}" \
  -e PGHOST="${db_host}" \
  -e PGPORT="${db_port}" \
  -e PGDATABASE="${db_name}" \
  -e PGUSER="${db_user}" \
  -e PGPASSWORD="${db_password}" \
  -e DATABASE_URL="postgres://${db_user}:${db_password}@${db_host}:${db_port}/${db_name}" \
  -e PORT=3000 \
  reservas-api
