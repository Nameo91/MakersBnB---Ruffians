require 'sinatra/activerecord'

class Request < ActiveRecord::Base
  validates_presence_of :start_date, :end_date, :space_id, :user_id

  belongs_to :users
  belongs_to :spaces
end
    