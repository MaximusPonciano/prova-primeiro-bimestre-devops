## 📝 Descrição do Pull Request

<!-- Explique de forma clara e objetiva o que este PR resolve ou adiciona. -->
- **Objetivo:** 


## ✅ Checklist de Qualidade (DevSecOps)

Antes de solicitar a revisão, certifique-se de que todos os itens abaixo foram cumpridos rigorosamente conforme as Regras do Repositório:

### 🐳 Backend & Docker
- [ ] A aplicação não roda como `root` no Dockerfile (`USER node`).
- [ ] O código utiliza ES Modules (`import`/`export`) e segue o SRP (Single Responsibility Principle).
- [ ] Os erros são tratados globalmente e não há vazamento de metadados.
- [ ] A coleção do Postman (`docs/Postman_Collection.json`) foi atualizada com as novas rotas.
- [ ] O comando `docker compose build` passa sem erros locais.

### ☁️ Infraestrutura (Terraform & AWS)
- [ ] **REGRA CRÍTICA**: Nenhum recurso de IAM (`aws_iam_role`, `aws_iam_user`, etc) foi criado no código (Restrição do Learner Lab).
- [ ] Foi utilizada apenas a `LabRole` e `LabInstanceProfile`.
- [ ] A região da AWS está fixada em `us-east-1`.
- [ ] Os comandos `terraform fmt` e `terraform validate` foram executados com sucesso.
- [ ] NENHUMA credencial estática ou arquivo `.tfstate` foi vazado neste PR.


---
*Revisado pelo Agente QA-Auditor-DevOps* 🕵️‍♂️
