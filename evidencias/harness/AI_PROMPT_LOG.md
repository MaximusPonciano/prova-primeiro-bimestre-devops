# 🏛️ Relatório Central de Inteligência Artificial (Audit Trail & Copilot Log)

> **Projeto:** API de Reservas — TechNova  
> **Disciplina:** DevOps (2026.2) — Prof. Alexandre da Costa Tavares Jr  
> **Ambiente:** Docker Compose (Local) & AWS Academy Learner Lab (`us-east-1`)  
> **Metodologia:** Spec-Driven Development (SDD) com Antigravity Harness & Action Controllers (SRP)

---

## 📋 Apresentação do Log Auditável

Este documento registra a jornada completa do projeto (Aulas 01 a 07), detalhando as interações com a Inteligência Artificial (Gemini / Claude) atuando como copiloto de desenvolvimento e arquitetura. O registro demonstra a transição de solicitações iniciais até o refino de uma arquitetura resiliente, segura e em conformidade com as diretrizes da AWS e da disciplina.

---

## 💻 Fase 1: Construção da API Node.js/Express (ESM, Action Controllers & PostgreSQL)

**Objetivo/Prompt**:
> *"Desenvolver a API de Reservas da TechNova em Node.js/Express utilizando o padrão moderno ES Modules (`"type": "module"`). O banco de dados relacional deve ser o PostgreSQL e a arquitetura da aplicação deve aplicar estritamente o Princípio da Responsabilidade Única (SRP) via Action Controllers, segregando cada operação CRUD (`POST`, `GET`, `GET/:id`, `PUT`, `DELETE`) e o endpoint de healthcheck (`GET /health`)."*

**O que gerou bem**:
- Implementação completa das rotas com tratamento de erros centralizado, validação de payloads com schemas e pooling de conexões resilientes com o PostgreSQL (`pg`).
- Criação dos scripts de migração SQL (`migrations/` e `init.sql`) configurados de forma totalmente idempotente (`CREATE TABLE IF NOT EXISTS`).

**Correções Necessárias**:
- A primeira versão gerada pela IA concentrou a lógica de rotas e persistência dentro de um único arquivo controlador monolítico (`reservasController.js`). O usuário interveio pontuando que a aplicação deveria seguir rigorosamente o padrão de **Action Controllers**, separando uma classe/arquivo por ação:
  - `CreateReservaController.js`
  - `ListReservaController.js`
  - `GetReservaController.js`
  - `UpdateReservaController.js`
  - `DeleteReservaController.js`
- A IA acatou a refatoração imediatamente, reestruturando as rotas e exportações em ES Modules.

---

## 🐳 Fase 2: Containerização & Orquestração Local (Dockerfile & Docker Compose)

**Objetivo/Prompt**:
> *"Elaborar a estratégia de containerização da API de Reservas com um `Dockerfile` otimizado seguindo as melhores práticas de DevSecOps (multi-stage build e usuário não-privilegiado `node`). Em seguida, criar o arquivo `docker-compose.yml` para orquestrar a API e o PostgreSQL em uma rede customizada bridge, configurando volumes nomeados para persistência e `healthcheck` no banco de dados."*

**O que gerou bem**:
- Construção do `Dockerfile` multi-stage dividindo as etapas de build de dependências e execução final (`alpine`), reduzindo drasticamente o tamanho da imagem e aplicando `USER node`.
- Configuração do `.dockerignore` para prevenir a inclusão de `node_modules` e `.env` no contexto da imagem.
- Orquestração do `docker-compose.yml` com a diretiva `depends_on: db: condition: service_healthy` baseada na execução do `pg_isready`.

**Correções Necessárias**:
- A IA inicialmente esqueceu de expor o comando de healthcheck do PostgreSQL de forma compatível com imagens leves (`pg_isready -U postgres`), o que fazia a API tentar se conectar antes do banco aceitar conexões. A IA corrigiu o bloco `healthcheck` e adicionou a variável `.env.example` para documentar as credenciais de desenvolvimento.

---

## 🧹 Fase 3: Análise Estática & Padronização DevSecOps (ESLint, Prettier & Git Workflow)

**Objetivo/Prompt**:
> *"Configurar as ferramentas de qualidade estática de código (ESLint com flat config e Prettier) na pasta `app/`, integrar hooks do Husky para validação automática de commits e garantir a conformidade com o padrão Conventional Commits (`feat:`, `fix:`, `infra:`, `docs:`, `chore:`) em um fluxo de feature branches."*

**O que gerou bem**:
- Instalação e configuração do ESLint e Prettier com regras estritas de formatação de código JavaScript ESM.
- Disponibilização dos scripts `npm run format` e `npm run lint:fix` no `package.json`.

**Correções Necessárias**:
- Durante os testes de versionamento, a IA recomendou realizar o commit das alterações diretamente na branch `main`. O usuário identificou o desvio de processo e exigiu a execução dentro de uma branch dedicada (`feature/app-crud`), reforçando a necessidade do fluxo de *Pull Request* e mantendo a branch principal protegida.

---

## ☁️ Fase 4: Infraestrutura como Código — Remote State (Terraform S3 + DynamoDB)

**Objetivo/Prompt**:
> *"Desenvolver o código Terraform em `infra/backend/` responsável por provisionar a infraestrutura do Remote State na AWS (Bucket S3 com versionamento e encriptação AES256, e tabela DynamoDB com a chave `LockID` para gerenciamento de state locking)."*

**O que gerou bem**:
- Criação dos recursos de backend do Terraform garantindo a integridade e concorrência das execuções em equipe.

**Correções Necessárias**:
- A IA tentou inicialmente declarar a configuração do backend dentro do arquivo `main.tf` principal da infraestrutura. O usuário exigiu a separação física na pasta `infra/backend/`.
- Adicionalmente, ao ser solicitada a realizar uma revisão criteriosa de segurança (*DevSecOps Audit*), a IA identificou que o bucket S3 não continha o bloco `aws_s3_bucket_public_access_block`, o que poderia expor o arquivo de estado `terraform.tfstate`. A IA corrigiu a falha inserindo o bloqueio público irrestrito antes da aplicação.

---

## 🌐 Fase 5: Provisionamento AWS Learner Lab Modularizado (VPC, SG, EC2 & RDS)

**Objetivo/Prompt**:
> *"Projetar e implementar a infraestrutura em nuvem modularizada para o AWS Academy Learner Lab na região `us-east-1`. A arquitetura deve conter: (1) Módulo VPC com subnets públicas e privadas em 2 AZs; (2) Módulo Security Group com menor privilégio; (3) Módulo EC2 na subnet pública utilizando `LabInstanceProfile`; e (4) Módulo RDS PostgreSQL em subnets privadas com `publicly_accessible = false` e encriptação em repouso."*

**O que gerou bem**:
- Otimização dos módulos Terraform segregados em `infra/modules/` (`vpc`, `security-group`, `ec2`, `rds`).
- Adesão completa às restrições do AWS Learner Lab: utilização de `data.aws_iam_role.lab_role` e `iam_instance_profile = "LabInstanceProfile"`, sem tentar criar recursos de IAM (`aws_iam_role`).
- Isolamento estrito do banco de dados RDS PostgreSQL (aceitando tráfego na porta 5432 apenas proveniente do Security Group da EC2).

**Correções Necessárias**:
- Durante a etapa de auditoria automática antes do `terraform apply`, a IA identificou três inconsistências críticas no seu próprio código:
  1. O módulo `rds` havia sido omitido na primeira versão da composição do `main.tf`.
  2. Faltava a variável `key_name` no módulo EC2, o que impediria acessos SSH de manutenção.
  3. O script `userdata.sh.tpl` da EC2 estava tentando executar `docker-compose up` referente ao ambiente local. A IA refatorou o script de inicialização para executar a imagem Docker da API conectando-se diretamente ao endpoint do RDS provisionado via variáveis de ambiente.

---

## 📖 Fase 6: Documentação Interativa da API (Swagger UI & Postman Collection)

**Objetivo/Prompt**:
> *"Gerar a documentação de API interativa para consumo do time de testes e entrega do projeto, incluindo a OpenAPI/Swagger UI integrada à aplicação em `/api-docs` e a criação da coleção Postman oficial em `docs/Postman_Collection.json`."*

**O que gerou bem**:
- Criação e integração do `swagger.json` e rotas de visualização da documentação no Express.
- Construção do arquivo `docs/Postman_Collection.json` mapeando todos os endpoints com variáveis de ambiente (`baseUrl`), permitindo testes imediatos das requisições `POST`, `GET`, `PUT`, `DELETE` e `healthcheck`.

**Correções Necessárias**:
- A IA precisou ajustar a tipagem dos dados no contrato da coleção Postman para garantir que o envio do campo `data` em ISO 8601 e o retorno dos códigos de status HTTP 201 e 200 estivessem 100% coerentes com os testes automatizados da API.

---

## 📊 Fase 7: Coleta de Evidências, Relatório Final & Submissão por Pull Request

**Objetivo/Prompt**:
> *"Executar os comandos de validação estática e funcional (`terraform fmt`, `terraform validate`, `docker compose ps`, `docker build`), capturar todas as evidências na pasta `evidencias/`, auxiliar na redação dissertativa de `relatorio.md` (respondendo às 4 questões sobre a jornada, uso da IA, AWS e validação) e estruturar o arquivo de submissão `entrega.md`."*

**O que gerou bem**:
- Geração dos logs de evidências em `evidencias/` (`docker-build.txt`, `compose-ps.txt`, `terraform-plan.txt`, `terraform-validate.txt`).
- Escrita dissertativa e fundamentada das 4 questões do relatório `relatorio.md`, destacando o pensamento crítico no uso da IA como copiloto.
- Elaboração do modelo `entrega.md` pronto para o envio do Pull Request na disciplina.

**Correções Necessárias**:
- Garantir a inclusão e verificação do registro de destruição dos recursos (`terraform destroy`) no relatório, prevenindo o esgotamento dos créditos do AWS Academy Learner Lab após a captura das evidências.

---

## 🔍 Fase 8: Troubleshooting em Produção (AWS RDS PostgreSQL 15 & SSL)

**Objetivo/Prompt**:
> *"Investigar e corrigir o motivo pelo qual a API retornava status 'degraded' e 'db: disconnected' logo após o deploy na AWS, mesmo com o RDS constando como ativo."*

**O que gerou bem**:
- Análise de logs da aplicação, inspeção da rede e Security Groups (verificando se o tráfego da EC2 chegava no RDS pela porta 5432).
- Diagnóstico certeiro de que o problema não era conectividade de rede, mas sim os requisitos de criptografia do banco.

**Correções Necessárias**:
- O AWS RDS, ao utilizar o engine `postgres` na versão 15, altera o `parameter_group` padrão para forçar conexões com SSL (`rds.force_ssl=1`). A IA detectou que o script de *userdata* (`userdata.sh.tpl`) inicializava o contêiner sem habilitar a flag de SSL suportada pela aplicação.
- A IA corrigiu o script adicionando `-e DB_SSL="true"`, realizou o `terraform taint` na EC2 para forçar a recriação limpa com o novo userdata, executou o `terraform apply` novamente e atestou que a comunicação entre API e RDS passou a ocorrer perfeitamente (retornando HTTP 200).

---

## ⚖️ Conclusão da IA (Análise Comparativa: Manual vs. Copiloto)

A atuação da Inteligência Artificial como copiloto no projeto apresentou ganhos expressivos de produtividade, exigindo porém supervisão arquitetural constante por parte do desenvolvedor:

- **Produtividade e Agilidade (Ganhos)**: A IA acelerou drasticamente a geração de código repetitivo (*boilerplate* HCL do Terraform, estruturas de Express, definições de schemas Swagger e arquivos Docker multi-stage). Tarefas que exigiriam horas de consulta à documentação foram concluídas em minutos.
- **Governança e Pensamento Crítico (Supervisão Exigida)**: A IA tendeu inicialmente a propor soluções simplistas ou monolíticas (como agrupar rotas em um único controlador ou ignorar regras de isolamento de infraestrutura). A intervenção ativa do Desenvolvedor (atuando como Arquiteto Técnico) foi fundamental para barrar desvios, impor o padrão **Action Controllers (SRP)** e exigir conformidade com o **AWS Learner Lab**.
