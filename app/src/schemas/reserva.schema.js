import { z } from 'zod';

export const createReservaSchema = z.object({
  body: z.object({
    cliente: z.string({
      required_error: 'O nome do cliente é obrigatório',
      invalid_type_error: 'O cliente deve ser um texto'
    }).min(3, 'O nome deve ter no mínimo 3 caracteres'),
    data: z.string({
      required_error: 'A data da reserva é obrigatória',
    }).regex(/^\d{4}-\d{2}-\d{2}$/, 'A data deve estar no formato YYYY-MM-DD'),
    status: z.string({
      required_error: 'O status é obrigatório',
    })
  })
});

// Para este CRUD simples, a atualização requer a mesma validação da criação
export const updateReservaSchema = createReservaSchema;

export const paramsIdSchema = z.object({
  params: z.object({
    id: z.coerce.number({
      required_error: "ID é obrigatório",
      invalid_type_error: "O ID deve ser um número válido"
    }).positive("O ID deve ser maior que zero")
  })
});
