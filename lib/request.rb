require 'sinatra/activerecord'

class Request

  validates_presence_of :dates, :space_id, :user_id

  has_many spaces
  has_many users
end
    