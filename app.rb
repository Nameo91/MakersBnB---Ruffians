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

    return erb(:index)
  end

  get '/signup' do

    return erb(:signup)
  end

  get '/login' do

    return erb(:login)
  end

  get '/spaces' do
    #returns a page with a list of all spaces
    #n.b. future task return just first 10 spaces
  end

  get '/space/new' do
    #returns the form page for creating a new space
  end

  post '/space' do
    #adds a new space to the spaces page
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
end