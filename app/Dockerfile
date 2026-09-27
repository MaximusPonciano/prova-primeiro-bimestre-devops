# Estágio 1: Dependências
FROM node:22-alpine AS deps
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --omit=dev

# Estágio 2: Produção (Imagem segura, otimizada e sem root)
FROM node:22-alpine AS runner
WORKDIR /usr/src/app

# Regra 4: Segurança - Nunca rodar como root
USER node

# Copiando apenas o necessário do estágio de dependências
COPY --chown=node:node --from=deps /usr/src/app/node_modules ./node_modules
COPY --chown=node:node package.json ./
# Copiando o código fonte da API
COPY --chown=node:node src/ ./src/

EXPOSE 3000

# Executando o servidor e as migrações na inicialização do container
CMD ["sh", "-c", "npm run migrate up && node src/index.js"]
