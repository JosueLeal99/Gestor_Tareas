require 'active_record'
require 'bcrypt'

class Usuario < ActiveRecord::Base
  has_many :tareas
  has_secure_password
end

class Tarea < ActiveRecord::Base
  belongs_to :usuario
end
