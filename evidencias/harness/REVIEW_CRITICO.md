# 🕵️ Relatório de Auditoria QA & Review Crítico

Este documento foi gerado através do `qa-auditor-devops` e reflete a auditoria final sobre o código-fonte (HCL, JavaScript/Node.js) e a documentação. Todas as falhas identificadas já foram corrigidas na base de código.

---

## 🚨 1. Identificação do Erro: Validação Frouxa no Zod (Schema de Reserva)
- **Arquivo**: `app/src/schemas/reserva.schema.js`
- **O que estava errado**: O campo `status` estava tipado genericamente como `z.string()`, aceitando qualquer palavra, mesmo a documentação oficial (`README.md`) e o Swagger exigirem um Enum específico (`pendente`, `confirmada`, `cancelada`).

**💥 A Falha/Risco**:
Qualquer usuário mal-intencionado (ou erro de front-end) poderia injetar valores espúrios (como `status: "hackeado"`) no banco de dados. Isso quebra a integridade relacional do sistema e gera inconsistência no consumo de dados.

**💎 A Boa Prática de Mercado**:
O contrato de API (Schema) deve ser a primeira e mais rígida barreira de segurança de uma aplicação. Tipagens de *status* e *flags* devem obrigatoriamente utilizar Enums estritos em vez de strings abertas.

**🛠️ A Solução Aplicada**:
Refatoração da validação no Zod substituindo `z.string()` por `z.enum()`:
```javascript
status: z.enum(['pendente', 'confirmada', 'cancelada'], {
  required_error: 'O status é obrigatório',
  invalid_type_error: 'O status deve ser: pendente, confirmada ou cancelada',
})
```

---

## 🚨 2. Identificação do Erro: Divergência entre Arquitetura EC2 e a Documentação
- **Arquivo**: `README.md` (Linha 54) vs `infra/modules/security-group/main.tf`
- **O que estava errado**: O `README.md` afirmava que o Security Group da EC2 expunha a porta `3000` para a internet, mas o código Terraform (corretamente) expunha a porta `80` nativa do protocolo HTTP.

**💥 A Falha/Risco**:
Divergência entre código e documentação gera confusão no time de Operações (SRE) e pode levar à configuração errônea de firewalls e WAFs em ambientes superiores. Documentação desatualizada é um dos maiores causadores de incidentes em esteiras DevSecOps.

**💎 A Boa Prática de Mercado**:
A infraestrutura provisionada em nuvem é sempre a "Fonte da Verdade". Se a EC2 utiliza o mapeamento nativo HTTP (80) roteado para o contêiner interno na porta 3000 (via `-p 80:3000`), a documentação técnica deve refletir a porta de borda (Security Group).

**🛠️ A Solução Aplicada**:
Correção direta na documentação (README):
```diff
- SG da EC2 liberando apenas portas essenciais (22, 3000).
+ SG da EC2 liberando apenas portas essenciais (22, 80).
```

---

## 🚨 3. Identificação do Erro: Sujeira de Artefatos no Repositório (Swagger Duplicado)
- **Arquivo**: `app/src/swagger.json`
- **O que estava errado**: Existia um arquivo estático monolítico (`swagger.json`) esquecido na raiz do projeto, enquanto a arquitetura moderna da aplicação já havia migrado para a pasta `app/src/swagger/` consumindo JSONs modularizados (`info.json`, `post-reservas.json`, etc) através de ESM.

**💥 A Falha/Risco**:
"Dead code" (código morto) e arquivos fantasmas causam confusão para novos desenvolvedores, que poderiam atualizar o arquivo errado ao modificar contratos de API.

**💎 A Boa Prática de Mercado**:
O que não é usado deve ser removido. Em arquiteturas baseadas em componentes (como o Swagger desta API), manter *stubs* estáticos desatualizados fere a regra de clareza do repositório.

**🛠️ A Solução Aplicada**:
Deleção do artefato órfão.

---

## 📋 Conclusão do QA Auditor
A infraestrutura AWS **atende plenamente** aos requisitos de conformidade restritiva (`LabRole` preservada, nenhum IAM criado, RDS isolado em subnets privadas sem acesso à internet). O Node.js possui um *Docker multi-stage* extremamente blindado rodando como usuário restrito `node`. A auditoria finaliza validando que **o código e a documentação estão finalmente 100% sincronizados**.
