# Relatório da Prova do Primeiro Bimestre

**Aluno:** Maximus Ponciano
**Ferramenta de IA utilizada:** Claude Code / Antigravity

---

### Questão 1 — A Jornada Completa (Aulas 01 a 07)

A jornada de desenvolvimento desta prova refletiu exatamente o ciclo de vida de uma aplicação real no contexto de DevOps. A primeira etapa foi preparar o repositório **Git**, garantindo um histórico limpo com Conventional Commits e padronizando o `.gitignore`. Em seguida, foquei na aplicação Node.js (API de Reservas), desenhando uma arquitetura MVC e aplicando validações com Zod (Aula 01). Com o código funcionando, criei um **Dockerfile** utilizando Multi-Stage Build e removendo o usuário `root` para aumentar a segurança.

Com a aplicação "empacotada", o próximo passo foi orquestrá-la localmente utilizando o **Docker Compose** (Aula 02), subindo a API e o PostgreSQL em conjunto numa rede privada, atrelando healthchecks rigorosos para garantir que a API só inicializasse após o banco estar saudável.

Finalmente, com o ambiente local homologado, a transição para a nuvem foi feita via **Terraform** (Aulas 03 a 06). Em vez de construir recursos monolíticos, criei uma infraestrutura **modular** separando responsabilidades: a rede (`vpc`), a segurança (`security-group`), a base de dados (`rds`) e o servidor de aplicação (`ec2`). Todo o estado dessa infraestrutura foi centralizado através do **Remote State** (S3 + DynamoDB), fechando o ciclo de automação ponta a ponta (Aula 07).

---

### Questão 2 — O Processo com IA como Copiloto

Durante todo o desenvolvimento, utilizei o Claude/Antigravity através de um modelo focado em **Spec-Driven Development** (desenvolvimento guiado por especificações). O fluxo começou detalhando exatamente o que eu queria em arquivos Markdown (`docs_/PLANO_DE_ACAO_PROVA.md`, `PLANO_BLINDAGEM.md`, etc.). A IA leu essas especificações (requisitos → design → tarefas) e gerou os artefatos de código correspondentes.

A IA foi brilhante em criar as estruturas base rapidamente, como o template dos módulos Terraform e as configurações iniciais do Express. Contudo, houveram momentos onde foi necessário corrigir ou "podar" sugestões excessivas (por exemplo, configurações de rede ou IAM fora das restrições do Learner Lab). 

Se eu tivesse feito tudo isso 100% de forma manual, teria gasto dezenas de horas lidando com boilerplate (digitação do boilerplate do Express, das sintaxes repetitivas do HCL no Terraform, etc). Por outro lado, o uso da IA não dispensa a revisão; a arquitetura teve de ser desenhada e policiada por mim o tempo todo para que o resultado final fosse conciso e seguro.

---

### Questão 3 — Infraestrutura, Segurança e o Learner Lab

A infraestrutura provisionada foi construída pensando em alta segmentação (Defesa em Profundidade). A **VPC** atua como contorno isolando meus recursos. Dentro dela, há uma quebra clara:
- A **Camada Pública** (Public Subnets) abriga a **EC2**, que roda a API e precisa responder para a Internet (porta 3000) e receber acesso SSH temporário.
- A **Camada Privada** (Private Subnets) resguarda o **RDS PostgreSQL**. Ele não possui IP público e o seu Security Group aceita conexões *exclusivamente* vindas do Security Group da EC2. Essa configuração garante que o banco de dados seja inalcançável diretamente pela Internet.

O **AWS Academy Learner Lab** impõe um "sandboxing" estrito: não é possível usar recursos customizados de IAM, o que me forçou a injetar a `LabRole` por ARN ou utilizar o `LabInstanceProfile` nativo para a EC2. Além disso, lidar com credenciais temporárias (Session Token) que expiram me fez reforçar o cuidado em não vazar chaves de sessão no Git e em reaplicar o ambiente local via variáveis com frequência.

---

### Questão 4 — Validação e Responsabilidade

Antes de rodar qualquer `terraform apply` gerado pela IA, eu criei o hábito inegociável de aplicar dois comandos vitais: `terraform validate` para checar a sanidade sintática e, especialmente, o `terraform plan`. O plano (`plan`) atua como meu principal *checklist*, pois revela a lista de inclusões/alterações exatas, como portas abertas num Security Group ou instâncias públicas sendo lançadas sem querer.

Eu validei a segurança certificando-me de que o RDS estava na subnet privada e que nenhuma Role nova estaria sendo inventada. Aceitar o código de uma IA sem revisão seria um desastre: provavelmente eu enfrentaria falhas de provisionamento constantes (AccessDenied no Learner Lab) ou, pior, subiria um banco de dados aberto para o mundo. 

Ter acompanhado a evolução natural desde o **Git local** (revertendo falhas) → passando por **Docker** (isolando falhas) → até os **Módulos do Terraform** construiu em mim a base para compreender onde cada componente atua. Quando a IA sugere um código "errado" de rede, agora eu sei que a culpa não é do Node, mas sim do Security Group do Terraform. Isso prova que a IA automatiza a digitação, mas a responsabilidade e o "norte" arquitetural continuam sendo meus.
