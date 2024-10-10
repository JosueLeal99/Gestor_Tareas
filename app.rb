require 'sinatra'
require 'sinatra/reloader' if development?
require './db'
require './models'
require 'sinatra/flash'
require 'bcrypt'

enable :sessions
register Sinatra::Flash

get '/' do
  erb :index
end

get '/signup' do
  erb :signup
end

post '/signup' do
  usuario = Usuario.new(username: params[:username])
  usuario.password = params[:password]
  if usuario.save
    session[:usuario_id] = usuario.id
    redirect '/tasks'
  else
    flash[:error] = "Error al crear el usuario"
    redirect '/signup'
  end
end

get '/login' do
  erb :login
end

post '/login' do
  usuario = Usuario.find_by(username: params[:username])
  if usuario && usuario.authenticate(params[:password])
    session[:usuario_id] = usuario.id
    redirect '/tasks'
  else
    flash[:error] = "Usuario o contraseña incorrectos"
    redirect '/login'
  end
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/tasks' do
  if params[:order] == 'etiqueta'
    @tareas = Tarea.where(usuario_id: session[:usuario_id]).order('etiqueta ASC')
  else
    @tareas = Tarea.where(usuario_id: session[:usuario_id]).order('fecha_vencimiento ASC')
  end
  erb :tasks
end

post '/tasks' do
  Tarea.create(titulo: params[:titulo], descripcion: params[:descripcion], fecha_vencimiento: params[:fecha_vencimiento], etiqueta: params[:etiqueta], estado: params[:estado] == "completada", usuario_id: session[:usuario_id])
  redirect '/tasks'
end

post '/tasks/:id/delete' do
  tarea = Tarea.find(params[:id])
  tarea.destroy
  redirect '/tasks'
end

post '/tasks/:id/toggle' do
  tarea = Tarea.find(params[:id])
  tarea.update(estado: !tarea.estado)
  redirect '/tasks'
end

get '/tasks/:id/edit' do
  @tarea = Tarea.find(params[:id])
  erb :edit_task
end

post '/tasks/:id' do
  tarea = Tarea.find(params[:id])
  tarea.update(titulo: params[:titulo], descripcion: params[:descripcion], fecha_vencimiento: params[:fecha_vencimiento], etiqueta: params[:etiqueta], estado: params[:estado] == "completada")
  redirect '/tasks'
end
