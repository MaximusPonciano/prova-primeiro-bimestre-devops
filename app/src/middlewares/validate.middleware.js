export const validate = (schema) => (req, res, next) => {
  try {
    schema.parse({
      body: req.body,
      query: req.query,
      params: req.params,
    });
    next();
  } catch (error) {
    return res.status(400).json({
      error: 'Erro de Validação (Bad Request)',
      details: error.errors.map((err) => ({
        campo: err.path.join('.'),
        mensagem: err.message,
      })),
    });
  }
};
