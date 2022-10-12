require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative 'lib/user'
require_relative 'lib/space'
require_relative 'lib/request'

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    display_active_user
    return erb(:index)
  end

  get '/signup' do
    return erb(:signup)
  end

  get '/login' do

    return erb(:login)
  end

  get '/spaces' do
    @spaces = Space.all
    return erb(:spaces)
  end

  get '/spaces/new' do
    return erb(:add_space)
  end

  get '/spaces/:id' do
    @space = Space.find(params[:id])
    return erb(:space_name)
  end

  post '/spaces' do
    Space.create!(
      space_name: params[:space_name],
      description: params[:description],
      price_per_night: params[:price_per_night]
    )
    redirect '/spaces'
  end

  post '/signup' do
    @new_user = User.create(
      first_name: params[:first_name],
      last_name: params[:last_name],
      username: params[:username],
      email: params[:email],
      mobile_number: params[:mobile_number],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    
    if !!@new_user.save
      redirect '/login'
    else
      return erb(:signup_errors)
    end
  end

  post '/login' do
    @email = params[:email]
    @password = params[:password]

    @user = User.find_by_email(@email)

    if @user && @user.authenticate(@password)
      session[:user_id] = @user.id

      redirect '/'
    else 

      return erb(:login_error)
    end
  end

  def display_active_user
    if !!session[:user_id]

      user = User.find_by_id(session[:user_id])
      # session[:user_id][:user] = user
      @active_user = user.username
    else
      @active_user = "Nobody's logged in!"
    end
  end
end