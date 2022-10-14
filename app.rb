require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative 'lib/user'
require_relative 'lib/space'
require_relative 'lib/request'
require 'date'

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @user = session[:user]

    return erb(:index)
  end

  get '/signup' do
    if login?
      @user = session[:user]
      
      return erb(:logged_in_error)
    end

    return erb(:signup)
  end

  get '/login' do
    if login?
      @user = session[:user]
      
      return erb(:logged_in_error)
    end

    return erb(:login)
  end

  get '/logout' do
    session.clear 
    
    redirect '/'
  end

  get '/spaces' do
    @spaces = Space.all
    @user = session[:user]

    return erb(:spaces)
  end

  get '/spaces/new' do
    # add logic to bar access if not logged in
    if login?
      @user = session[:user]
      return erb(:add_space)
    end

    redirect '/login'
  end

  get '/spaces/:id' do
    @date = DateTime.now.strftime("%Y-%m-%d")
    @space = Space.find(params[:id])
    @requests = Request.all
    @user = session[:user]
    @booking = Request.find_by_space_id(@space.id)

    return erb(:space_id, :layout => :layout)
  end

  get '/request_submitted' do
    @user = session[:user]
    
    return erb(:request_submitted)
  end

  get '/request_error' do
    
    return
  end

  post '/spaces' do
    @user = session[:user]
    @space = Space.create(
      space_name: params[:space_name],
      description: params[:description],
      price_per_night: params[:price_per_night],
      user_id: session[:user_id]
    )
    
    if !!(@space.save)
    redirect '/spaces'
    else

    return erb(:new_space_error)
    end
  end

  post '/spaces/:id' do
    space_id = params[:id]
    unless !!session[:user_id]
      redirect '/request_error'
    end
    request = Request.create(
      start_date: params[:start_date],
      end_date: params[:end_date],
      user_id: session[:user_id],
      space_id: space_id
    )
      space = Space.find(space_id)
      if session[:user_id] == space.user_id
        request.approval_status = true
      end
    if request.save
      redirect '/request_submitted'
    else
      redirect '/request_error'
    end
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

  def login? 
    !!session[:user]
  end

  def available?
    request = Request.space_id.available_status
    start_date_check = params[:start_date].between?(request[:start_date], request[:end_date])
    end_date_check = params[:end_date].between?(request[:start_date], request[:end_date])

    if request && start_date_check || end_date_check
      return false
    end
  end

  private 

  def string_to_date(x)
      to_date = Date.strptime(x, '%Y-%m-%d')
      from_date = to_date.strftime('%d %B %Y')
  end
end

