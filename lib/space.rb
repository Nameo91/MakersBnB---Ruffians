class Space 
  validates_confirmation of :space_name, :price_per_night

  has_many requests
  belongs to users
end