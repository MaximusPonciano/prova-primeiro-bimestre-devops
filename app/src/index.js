import express from 'express';
import helmet from 'helmet';
import cors from 'cors';

import reservasRoutes from './routes/reservas.routes.js';
import { errorHandler } from './middlewares/error.middleware.js';
import db from './config/database.js';

const app = express();

// Middlewares de Segurança (Blindagem)
app.use(helmet());
app.use(cors());
app.use(express.json());

// Injeção de Rotas MVC
app.use('/reservas', reservasRoutes);

// Rota inicial de Health Check
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    message: 'API de Reservas conectada e blindada com sucesso!',
  });
});

// Middleware Global de Tratamento de Erros (sempre no final)
app.use(errorHandler);

const PORT = process.env.PORT || 3000;
const server = app.listen(PORT, () => {
  console.log(`🚀 API rodando na porta ${PORT}`);
});

// 🛑 Graceful Shutdown para orquestração Cloud/Docker
const gracefullyShutdown = async (signal) => {
  console.log(
    `\n🛑 [${signal}] Sinal de morte recebido. Iniciando Graceful Shutdown...`
  );

  // 1. Para de receber novas requisições (mas termina as atuais)
  server.close(async () => {
    console.log('✅ Servidor HTTP enclausurado.');

    // 2. Fecha conexões seguras com o Banco de Dados
    try {
      await db.end();
      console.log('✅ Pool do PostgreSQL encerrado em paz.');
      process.exit(0);
    } catch (err) {
      console.error('❌ Erro macabro ao fechar banco de dados:', err);
      process.exit(1);
    }
  });
};

process.on('SIGTERM', () => gracefullyShutdown('SIGTERM')); // Enviado pelo Docker/Kubernetes
process.on('SIGINT', () => gracefullyShutdown('SIGINT')); // Enviado pelo CTRL+C do terminal
