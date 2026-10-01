# 🚀 Prova do Primeiro Bimestre — DevOps (API de Reservas)

- **Aluno:** Maximus Ponciano
- **RA:** 6325066
- **Disciplina:** DevOps — Análise e Desenvolvimento de Sistemas (2026.2)
- **Ferramenta de IA:** Claude Code / Antigravity

---

## 📖 Descrição do Projeto

Este repositório contém a solução completa para o ambiente da **API de Reservas** da TechNova. A aplicação foi construída em Node.js/Express com banco de dados PostgreSQL e passa por todo o ciclo de DevOps:
1. **Containerização:** Docker com *Multi-stage build* rodando em usuário não-root.
2. **Orquestração Local:** Docker Compose criando uma rede bridge entre a API e o Banco.
3. **Infraestrutura em Nuvem:** AWS (Academy Learner Lab) provisionada via **Terraform** de forma 100% modular (VPC, Security Groups, EC2 e RDS).
4. **Estado Remoto:** Configuração de Remote State do Terraform usando S3 + DynamoDB.

---

## 📡 API e Endpoints

A aplicação provê um CRUD completo persistindo no PostgreSQL. 

| Método | Rota | Descrição |
|--------|------|-----------|
| `POST` | `/reservas` | Cria uma reserva (valida campos obrigatórios via Zod) |
| `GET` | `/reservas` | Lista todas as reservas cadastradas |
| `GET` | `/reservas/:id` | Busca detalhada por `id` (Retorna `404` se não existir) |
| `PUT` | `/reservas/:id` | Atualiza dados de uma reserva |
| `DELETE` | `/reservas/:id` | Remove uma reserva |
| `GET` | `/health` | Health check da conexão e estabilidade do banco |

> **Formato Esperado (JSON):** Aceita `id`, `cliente`, `data`, `status` (`pendente`, `confirmada`, `cancelada`).

---

## 💻 1. Como rodar localmente (Desenvolvimento)

Para testar a aplicação na sua própria máquina antes de mandar para a nuvem:

**Pré-requisitos:** Docker e Docker Compose instalados.

```bash
# 1. Copie o arquivo de variáveis de ambiente
cp .env.example .env

# 2. Suba o ambiente via Docker Compose (em background)
docker compose up -d --build

# 3. Verifique se a API e o Banco estão saudáveis
docker compose ps

# 4. Teste a saúde da aplicação (deve retornar {"status":"ok"})
curl http://localhost:3000/health

# 5. Para derrubar o ambiente e limpar os volumes
docker compose down -v
```

---

## ☁️ 2. Como Subir na AWS (Produção)

A infraestrutura foi desenhada para a **AWS Academy Learner Lab** na região `us-east-1`, utilizando os perfis `LabRole` e `LabInstanceProfile`.

### 🔑 Passo A: Configurar Credenciais AWS
Como estamos usando o AWS Academy, as credenciais expiram a cada sessão. Você deve iniciar o laboratório e capturar as credenciais em **AWS Details → AWS CLI**.

**No Windows (PowerShell):**
Copie e cole as credenciais assim (basta colar o bloco do Learner Lab se ele vier em formato bash, mas o ideal em PowerShell é configurar assim):
```powershell
$env:AWS_ACCESS_KEY_ID="ASIA..."
$env:AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
$env:AWS_SESSION_TOKEN="IQoJb3JpZ2luX2Vj..."
```

**No Linux, macOS ou WSL (Bash/Zsh):**
Basta colar exatamente o bloco que a AWS fornece:
```bash
export AWS_ACCESS_KEY_ID="ASIA..."
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2Vj..."
```

---

### 📝 Passo B: Configurar Variáveis do Terraform

Na pasta `infra/`, existe um arquivo chamado `terraform.tfvars.example`. Ele serve como um "gabarito" documentando quais variáveis a sua infraestrutura precisa para ser criada (como o nome do projeto e credenciais do banco).

Antes de executar os comandos do Terraform, você precisa gerar o arquivo de variáveis real:
```bash
# Entre na pasta de infraestrutura
cd infra

# Crie a cópia do arquivo de exemplo
cp terraform.tfvars.example terraform.tfvars
```
Abra o `terraform.tfvars` recém-criado e altere a variável `db_password` para uma senha forte de sua preferência. **Importante:** O `terraform.tfvars` já foi adicionado ao `.gitignore` porque contém informações sensíveis e **nunca deve ser commitado no repositório**.

---

### 🏗️ Passo C: Comandos do Terraform

Sempre certifique-se de estar dentro da pasta de infraestrutura (`cd infra`) antes de executar os comandos a seguir.

**Compatibilidade:** Os comandos abaixo rodam **exatamente iguais** tanto no Windows (CMD/PowerShell), quanto no Linux, macOS ou WSL.

#### 1. Inicializar o Terraform
Baixa os provedores da AWS e configura o estado remoto.
```bash
terraform init
```

#### 2. Validar o Código
Verifica se não há erros de sintaxe nos seus módulos.
```bash
terraform validate
```

#### 3. Planejar a Infraestrutura (Plan)
Verifica o que será criado na nuvem ANTES de aplicar (o resultado esperado são *19 resources to add*).
```bash
terraform plan
```

#### 4. Aplicar e Criar os Recursos (Apply)
Esse comando cria tudo! VPC, Banco RDS privado e a EC2 rodando a API.
```bash
terraform apply -auto-approve
```
> Após a finalização, ele exibirá os `Outputs` na tela (URL da API, IP da EC2, etc). O script `userdata` da EC2 já instala o Docker e inicia a API de Reservas automaticamente. Demora cerca de 3 a 5 minutos para o banco RDS inicializar completamente.

#### 5. Destruir tudo (MUITO IMPORTANTE)
Como o Learner Lab consome créditos rapidamente, **SEMPRE** destrua os recursos ao terminar seus testes.
```bash
terraform destroy -auto-approve
```

---

## 📐 Arquitetura da Solução

* **Rede (VPC):** VPC segmentada com Subnets Públicas e Privadas em 2 Zonas de Disponibilidade.
* **EC2 (App):** Instância provisionada na camada pública contendo a aplicação containerizada. O acesso externo ocorre apenas nas portas 80/3000 e 22 (SSH).
* **RDS PostgreSQL (Database):** Instância provisionada na camada **privada**. Ela não recebe tráfego da internet, protegida por um Security Group que só permite conexões na porta 5432 provindas **exclusivamente** da instância EC2.
* **State Locking:** DynamoDB evita corridas de concorrência bloqueando o arquivo de estado no bucket S3 durante as execuções do Terraform.
