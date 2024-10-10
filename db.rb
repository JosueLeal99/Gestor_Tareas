require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.sqlite3'
)

ActiveRecord::Base.logger = Logger.new(STDOUT)

unless ActiveRecord::Base.connection.table_exists?(:Usuarios)
  ActiveRecord::Base.connection.create_table :Usuarios do |t|
    t.string :username
    t.string :password_digest
    t.timestamps
  end
end

unless ActiveRecord::Base.connection.table_exists?(:Tareas)
  ActiveRecord::Base.connection.create_table :Tareas do |t|
    t.string :titulo
    t.text :descripcion
    t.date :fecha_vencimiento
    t.string :etiqueta
    t.boolean :estado, default: false
    t.references :usuario, foreign_key: { to_table: :Usuarios }
    t.timestamps
  end
end
