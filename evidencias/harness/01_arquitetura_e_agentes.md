# Definição de Arquitetura e Estratégia de IA (Spec-Driven Development)

## 1. O Plano de Execução do Projeto
Toda a execução deste projeto baseou-se na metodologia de **Spec-Driven Development**. Em vez de codificarmos a esmo, a arquitetura foi desenhada previamente e dividida em fases lógicas. O fluxo de orquestração do projeto foi definido da seguinte maneira:

1. **Auditoria (Gap Analysis)**: Entender o baseline do repositório em comparação à rubrica oficial da prova.
2. **Desenvolvimento (API e Documentação)**: Padronizar os contratos da API e estabelecer a documentação viva através do padrão OpenAPI (Swagger).
3. **Continuous Integration (CI local)**: Bloquear regressões de estilo de código implementando uma esteira automatizada no pre-commit utilizando Husky, Lint-Staged e Prettier.
4. **Infraestrutura como Código (IaC)**: Projetar os pipelines do Terraform (Plan, Apply, Destroy) levando em consideração bloqueios do AWS Learner Lab, seguidos de ajustes dinâmicos de arquitetura de rede (Port Mapping) para expor a API de maneira profissional.

---

## 2. Orquestração de Agentes Customizados
Para garantir que a IA não tivesse "alucinações" e que o código aderisse a regras corporativas (ex: nunca usar `aws_iam_role` no Learner Lab ou não fazer documentação desestruturada), a Inteligência Artificial não foi utilizada como um "chatbot generalista".

Construímos um sistema de **Sub-Agentes Especialistas** mapeando o diretório de customização roots do Antigravity IDE (`.agents/skills/`). Dividimos as responsabilidades simulando um Squad de Engenharia:

- **`qa-auditor-devops`**: Responsável exclusivo por cruzar dados das specs contra repositórios e rubricas, e por validar testes.
- **`build-express-api`**: Carregava o contexto do Node.js, ciente de que deveria usar "Action Controllers" e ESM (ECMAScript Modules).
- **`ci-cd-engineer`**: Restrito à visão do Git e `package.json`, configurando webhooks e esteiras de linting.
- **`cloud-architect` / `deploy-terraform`**: Modelados com as restrições reais da AWS (uso mandatório da `LabRole`) e focados na gestão estrita do `terraform.tfstate` e Security Groups.

Esses agentes foram acionados ao longo das fases, elevando a precisão das entregas.
