import { ReservaModel } from '../../models/ReservaModel.js';
import asyncHandler from 'express-async-handler';

export default asyncHandler(async (req, res) => {
  const reservas = await ReservaModel.findAll();
  res.status(200).json(reservas);
});
