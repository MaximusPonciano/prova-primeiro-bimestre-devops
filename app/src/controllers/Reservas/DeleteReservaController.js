import { ReservaModel } from '../../models/ReservaModel.js';
import asyncHandler from 'express-async-handler';

export default asyncHandler(async (req, res) => {
  const { id } = req.params;
  const reserva = await ReservaModel.delete(id);

  if (!reserva) {
    res.status(404);
    throw new Error('Reserva não encontrada');
  }

  res.status(204).send();
});
