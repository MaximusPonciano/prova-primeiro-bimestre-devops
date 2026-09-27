exports.up = (pgm) => {
  pgm.createTable('reservas', {
    id: 'id',
    cliente: { type: 'varchar(255)', notNull: true },
    data: { type: 'date', notNull: true },
    status: { type: 'varchar(50)', notNull: true }
  }, {
    ifNotExists: true
  });
};

exports.down = (pgm) => {
  pgm.dropTable('reservas', { ifExists: true });
};
