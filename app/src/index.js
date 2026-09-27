const express = require('express');

const app = express();
app.use(express.json());

// Rota inicial de Health Check (Passo 1)
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', message: 'API de Reservas conectada com sucesso!' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 API rodando na porta ${PORT}`);
});
