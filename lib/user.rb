require 'sinatra/activerecord'
require 'bcrypt'

class User < ActiveRecord::Base
  has_secure_password 

  validates_presence_of :first_name, :last_name, :username, :email, :mobile_number, :password_confirmation
  validates_uniqueness_of :username, :email, :mobile_number
  validates_length_of :password, minimum: 8
  validates_confirmation_of :password 
  
  has_many :spaces
  has_many :requests
end