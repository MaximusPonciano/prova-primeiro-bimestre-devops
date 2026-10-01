# Prova do Primeiro Bimestre — DevOps (API de Reservas)

- **Aluno:** Maximus Ponciano
- **RA:** [6325066]
- **Disciplina:** DevOps — Análise e Desenvolvimento de Sistemas (2026.2)
- **Ferramenta de IA:** Claude Code / Antigravity

## Descrição

Ambiente completo e reproduzível da **API de Reservas** da TechNova: aplicação Node.js/Express com CRUD de `reservas` persistido em PostgreSQL. A aplicação está containerizada com Docker (multi-stage build sem root), orquestrada localmente com Docker Compose e provisionada na AWS (Learner Lab) com Terraform 100% modularizado (VPC, Security Groups, EC2 e RDS) e state remoto no S3 com lock via DynamoDB.

## API e Endpoints

| Método | Rota | Descrição |
|--------|------|-----------|
| `POST` | `/reservas` | Cria uma reserva (valida campos obrigatórios via Zod) |
| `GET` | `/reservas` | Lista todas as reservas ordenadas |
| `GET` | `/reservas/:id` | Busca por `id` (404 se não existir) |
| `PUT` | `/reservas/:id` | Atualiza uma reserva |
| `DELETE` | `/reservas/:id` | Remove uma reserva |
| `GET` | `/health` | Health check da conexão com o banco |

Campos aceitos na reserva: `id`, `cliente`, `data`, `status`. Valores aceitos no enum de `status`: `pendente` (padrão), `confirmada`, `cancelada`.

## Como rodar localmente (Desenvolvimento)

Pré-requisito: Docker com Docker Compose v2.

```bash
# 1. Copie o arquivo de variáveis de ambiente
cp .env.example .env

# 2. Suba o ambiente via Docker Compose
docker compose up -d --build

# 3. Verifique se os serviços (api e db) estão saudáveis
docker compose ps

# 4. Teste a saúde da aplicação
curl http://localhost:3000/health

# 5. Opcional: rode os testes de integração (fumaça)
bash app/smoke.sh

# 6. Para derrubar o ambiente (use -v para apagar os dados do banco)
docker compose down
```

## Infraestrutura AWS (Produção)

A infraestrutura foi desenhada e provisionada através do Terraform (`us-east-1` no AWS Academy Learner Lab).

- **Rede (VPC):** VPC `10.0.0.0/16` com 2 subnets públicas (para as EC2s/API) e 2 subnets privadas (para o banco de dados), com Internet Gateway configurado.
- **Segurança (Security Groups):** SG da EC2 liberando apenas portas essenciais (22, 3000). SG do Banco de Dados liberando a porta `5432` **apenas** para requisições com origem no SG da EC2.
- **Compute (EC2):** Instância `t2.micro` nas subnets públicas utilizando o `LabInstanceProfile`. O script de inicialização (`user_data`) clona o código e sobe o container da API de Reservas.
- **Banco de Dados (RDS PostgreSQL):** Instância gerenciada `db.t3.micro` provisionada isoladamente na camada privada, garantindo segurança a nível de arquitetura.
- **Remote State:** O controle de estado do Terraform utiliza um bucket S3 para armazenamento persistente e uma tabela DynamoDB nativa para controle de travas (state locking).

> Todos os serviços seguem as restrições da LabRole e utilizam `tags` de identificação em todos os recursos.
