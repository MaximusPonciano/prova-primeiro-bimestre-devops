import { ReservaModel } from '../../models/ReservaModel.js';
import asyncHandler from 'express-async-handler';

export default asyncHandler(async (req, res) => {
  const { cliente, data, status } = req.body;
  const reserva = await ReservaModel.create(cliente, data, status);
  res.status(201).json(reserva);
});
