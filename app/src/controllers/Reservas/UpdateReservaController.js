import { ReservaModel } from '../../models/ReservaModel.js';
import asyncHandler from 'express-async-handler';

export default asyncHandler(async (req, res) => {
  const { id } = req.params;
  const { cliente, data, status } = req.body;

  const reserva = await ReservaModel.update(id, cliente, data, status);

  if (!reserva) {
    res.status(404);
    throw new Error('Reserva não encontrada');
  }

  res.status(200).json(reserva);
});
