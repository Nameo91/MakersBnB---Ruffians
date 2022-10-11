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
end