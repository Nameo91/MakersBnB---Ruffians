require 'sinatra/activerecord'

class Space < ActiveRecord::Base
  validates_confirmation_of :space_name, :price_per_night, :description

  has_many :requests
  belongs_to :users
end