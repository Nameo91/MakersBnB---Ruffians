require 'sinatra/activerecord'

class Request < ActiveRecord::Base

  validates_presence_of :dates, :space_id, :user_id

  has_many :spaces
  has_many :users
end
    