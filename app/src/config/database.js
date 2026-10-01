import pkg from 'pg';
const { Pool } = pkg;

const poolConfig = process.env.DATABASE_URL
  ? {
      connectionString: process.env.DATABASE_URL,
      ssl:
        process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
      connectionTimeoutMillis: 10000,
    }
  : {
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 5432,
      user: process.env.DB_USER || 'admin',
      password: process.env.DB_PASS || 'adminpassword',
      database: process.env.DB_NAME || 'reservas_db',
      ssl:
        process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
      connectionTimeoutMillis: 10000,
    };

const pool = new Pool(poolConfig);

pool.on('error', (err) => {
  console.error('⚠️ Aviso do pool de conexões do PostgreSQL:', err.message);
});

export default {
  query: (text, params) => pool.query(text, params),
  end: () => pool.end(),
};
