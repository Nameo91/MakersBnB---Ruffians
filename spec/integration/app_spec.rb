# require "spec_helper"
# require "rack/test"
# require_relative '../../app'
# require 'json'

# describe Application do
#   # This is so we can use rack-test helper methods.
#   include Rack::Test::Methods

#   # We need to declare the `app` value by instantiating the Application
#   # class so our tests work.
#   let(:app) { Application.new }

#   # Write your integration tests below.
#   # If you want to split your integration tests
#   # accross multiple RSpec files (for example, have
#   # one test suite for each set of related features),
#   # you can duplicate this test file to create a new one.
#   before(:each) do
#     Space.create(space_name: 'makers', description: 'Awesome', price_per_night: '100', user_id: '1', request_id: '1')
#   end

#   # context 'GET /' do
#   #   it 'should get the homepage' do
#   #     @response = get('/')

#   #     200_ok?
#   #   end
#   # end

#   # context 'GET /spaces' do
#   #   it 'should show list of all spaces' do
#   #     @response = get('/spaces')

#   #     200_ok?
#   #     copy_test('<h1>Check out all spaces</h1>')
#   #     copy_test('makers')
#   #     copy_test('100')
#   #     copy_test('Awsome')
#   #   end
#   # end

#   private

#   def 200_ok?
#     expect(@response.status).to eq(200)
#   end

#   def copy_test(text)
#     expect(@response.body).to include(text)
#   end
# end
