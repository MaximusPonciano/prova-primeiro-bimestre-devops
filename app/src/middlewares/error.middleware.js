export const errorHandler = (err, req, res, next) => {
  console.error('🔥 Erro Capturado Globalmente:', err);

  const status = err.statusCode || 500;
  const message = err.message || 'Erro Interno no Servidor';

  res.status(status).json({
    error: message,
    // stack só aparece em ambiente de desenvolvimento (padrão de segurança)
    stack: process.env.NODE_ENV === 'development' ? err.stack : undefined
  });
};
