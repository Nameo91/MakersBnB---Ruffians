require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

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
  before(:each) do
    Space.create(id: 1, space_name: 'Makers HQ', description: 'Awesome', price_per_night: '100.0', user_id: '1', request_id: '1')
    Space.create(id: 2, space_name: 'Gherkin', description: 'A little corporate', price_per_night: '500.0', user_id: '2', request_id: '1')
    Request.create(id: 1, start_date: '2022-10-13', end_date: '2022-10-14', space_id: '1', user_id: '1')
    User.create(
      id: 1,  
      first_name: 'Calum', 
      last_name: 'Wilmot', 
      username: 'Cal', 
      email: 'calum@calum.com', 
      mobile_number: '11111111111', 
      password: 'CalumCalum', 
      password_confirmation: 'CalumCalum')
  end

  context 'GET /' do
    it 'gets the homepage' do
      @response = get('/')

      responds_ok?
    end
  end

  context 'GET /spaces' do
    it 'shows a list of all spaces' do
      @response = get('/spaces')

      responds_ok?
      copy_test('<h2>Check out all spaces</h2>')
      copy_test('Makers HQ')
      copy_test('£100.0')
      copy_test('Gherkin')
      copy_test('£500.0')
    end
  end

  context 'GET /spaces/new' do
    it 'returns an html form to add a new space' do
      @response = get('/spaces/new')

      responds_ok?
      copy_test('<form method="POST" action="/spaces">')
      copy_test('<input type="text" name="space_name">')
      copy_test('<input type="text" name="description">')
      copy_test('<input type="text" name="price_per_night">')
    end
  end


  context 'POST /spaces' do
    it 'Creates new space record' do
      @response = post('/spaces', space_name: 'Gherkin', price_per_night: '500.0', description: 'A little corporate')

      # responds_ok?
      expect(@response.status).to eq(302)
      expect(Space.last.space_name).to eq('Gherkin')
      expect(Space.last.description).to eq('A little corporate')
      # expect(Space.last.price_per_night).to eq('500')
    end
  end

  context 'GET /spaces/:id' do
    it 'Shows a single space' do
      @response = get('/spaces/2')
      
      responds_ok?
      copy_test('Gherkin')
      copy_test('£500.0')
      copy_test('A little corporate')
    end

    it 'Displays a calendar' do
      @response = get('/spaces/2')
      
      responds_ok?
      copy_test('Start Date')
      copy_test('End Date')
    end
  end

  private

  def responds_ok?
    expect(@response.status).to eq(200)
  end

  def copy_test(text)
    expect(@response.body).to include(text)
  end
end
