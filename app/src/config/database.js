import pkg from 'pg';
const { Pool } = pkg;

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || 'admin',
  password: process.env.DB_PASS || 'adminpassword',
  database: process.env.DB_NAME || 'reservas_db',
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

export default {
  query: (text, params) => pool.query(text, params),
  end: () => pool.end(),
};
