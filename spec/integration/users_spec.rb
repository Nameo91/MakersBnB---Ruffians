require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'
require_relative '../../lib/user.rb'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.
  before :each do
    user = User.create(first_name: 'Calum', last_name: 'Wilmot', username: 'Cal', email: 'calum@calum.com', mobile_number: '11111111111', password: 'CalumCalum')
  end

  it "" do
   new_user = User.create(first_name: 'Calum', last_name: 'Wilmot', username: 'Cal', email: 'calum@calum.com', mobile_number: '11111111111', password: 'CalumCalum')
   
   expect(new_user.save).to eq false
  end

end