import { readFile } from 'fs/promises';

const loadJSON = async (path) =>
  JSON.parse(await readFile(new URL(path, import.meta.url)));

const info = await loadJSON('./info.json');
const health = await loadJSON('./health.json');
const getReservas = await loadJSON('./get-reservas.json');
const postReservas = await loadJSON('./post-reservas.json');
const getReservaId = await loadJSON('./get-reserva-id.json');
const putReserva = await loadJSON('./put-reserva.json');
const deleteReserva = await loadJSON('./delete-reserva.json');

const swaggerDocument = {
  ...info,
  paths: {
    '/health': {
      ...health,
    },
    '/reservas': {
      ...getReservas,
      ...postReservas,
    },
    '/reservas/{id}': {
      ...getReservaId,
      ...putReserva,
      ...deleteReserva,
    },
  },
};

export default swaggerDocument;
