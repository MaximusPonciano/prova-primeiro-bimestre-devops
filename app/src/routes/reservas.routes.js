import express from 'express';

// Validação e Schemas
import { validate } from '../middlewares/validate.middleware.js';
import { createReservaSchema, updateReservaSchema, paramsIdSchema } from '../schemas/reserva.schema.js';

// Controladores
import CreateReservaController from '../controllers/Reservas/CreateReservaController.js';
import ListReservaController from '../controllers/Reservas/ListReservaController.js';
import GetReservaController from '../controllers/Reservas/GetReservaController.js';
import UpdateReservaController from '../controllers/Reservas/UpdateReservaController.js';
import DeleteReservaController from '../controllers/Reservas/DeleteReservaController.js';

const router = express.Router();

// O Zod barra payloads inválidos antes mesmo do código do controlador rodar
router.post('/', validate(createReservaSchema), CreateReservaController);
router.get('/', ListReservaController);
router.get('/:id', validate(paramsIdSchema), GetReservaController);
// Valida primeiro se o ID é número, depois valida o Body da alteração
router.put('/:id', validate(paramsIdSchema), validate(updateReservaSchema), UpdateReservaController);
router.delete('/:id', validate(paramsIdSchema), DeleteReservaController);

export default router;
