require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require_relative 'lib/user'
require_relative 'lib/space'
require_relative 'lib/request'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end


  get '/spaces' do
    @spaces = Space.all
    return erb(:spaces)
  end

  get '/space/new' do
    #returns the form page for creating a new space
  end

  post '/spaces' do
    #adds a new space to the spaces page
  end
end