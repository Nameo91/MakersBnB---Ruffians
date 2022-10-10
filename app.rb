require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
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
end