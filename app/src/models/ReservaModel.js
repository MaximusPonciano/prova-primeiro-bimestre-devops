import db from '../config/database.js';

export const ReservaModel = {
  create: async (cliente, data, status) => {
    const result = await db.query(
      'INSERT INTO reservas (cliente, data, status) VALUES ($1, $2, $3) RETURNING *',
      [cliente, data, status]
    );
    return result.rows[0];
  },

  findAll: async () => {
    const result = await db.query('SELECT * FROM reservas ORDER BY id ASC');
    return result.rows;
  },

  findById: async (id) => {
    const result = await db.query('SELECT * FROM reservas WHERE id = $1', [id]);
    return result.rows[0];
  },

  update: async (id, cliente, data, status) => {
    const result = await db.query(
      'UPDATE reservas SET cliente=$1, data=$2, status=$3 WHERE id=$4 RETURNING *',
      [cliente, data, status, id]
    );
    return result.rows[0];
  },

  delete: async (id) => {
    const result = await db.query('DELETE FROM reservas WHERE id=$1 RETURNING *', [id]);
    return result.rows[0];
  }
};
