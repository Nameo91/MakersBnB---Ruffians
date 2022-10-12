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
    @user = session[:user]
    return erb(:index, :layout => :layout)
  end

  get '/signup' do
    # needs logic to bar entry to page if user session is active
    @user = session[:user]
    return erb(:signup, :layout => :layout)
  end

  get '/login' do
    @user = session[:user]
    return erb(:login, :layout => :layout)
  end

  get '/logout' do
    session.clear  
  end

  get '/spaces' do
    @spaces = Space.all
    @user = session[:user]
    return erb(:spaces, :layout => :layout)
  end

  get '/spaces/new' do
    # add logic to bar access if not logged in
    @user = session[:user]
    return erb(:add_space, :layout => :layout)
  end

  get '/calendar_test' do
    return erb(:calendar_test)
  end

  get '/request_submitted' do
    return erb(:request_submitted)
  end

  post '/spaces' do
    Space.create!(
      space_name: params[:space_name],
      description: params[:description],
      price_per_night: params[:price_per_night]
    )
    redirect '/spaces'
  end

  get '/spaces/:id' do
    @space = Space.find(params[:id])
    @user = session[:user]
    return erb(:space_id, :layout => :layout)
  end

  post '/spaces/:id' do
    space_id = params[:id]
    if !!session[:user_id]
    request = Request.create(
      start_date: params[:start_date],
      end_date: params[:end_date],
      user_id: session[:user_id],
      space_id: space_id
    )
      if request.save
        redirect '/request_submitted'
      else
        redirect '/request_error'
      end
    end
  end

  get '/request_submitted' do
    @user = session[:user]
    return erb(:request_submitted, :layout => :layout)
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
      session[:user] = @user

      redirect '/'
    else 

      return erb(:login_error)
    end
  end
end