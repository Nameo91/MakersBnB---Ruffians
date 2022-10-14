require 'sinatra/activerecord'

class Space < ActiveRecord::Base
  validates_presence_of :space_name, :price_per_night, :description, :image

  has_many :requests
  belongs_to :users
end
