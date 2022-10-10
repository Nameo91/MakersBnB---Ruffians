require 'sinatra/activerecord'

class Space

  validates_presence_of :space_name, :description, :price_per_night, :user_id, :request_id
  validates_uniquenss_of :space_name, message: 'There is already a space with this name'

  has_many :requests
end