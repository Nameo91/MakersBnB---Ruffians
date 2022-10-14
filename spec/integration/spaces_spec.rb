require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods
  # include Rack::Test::Session

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  # Write your integration tests below.
  # If you want to split your integration tests
  # accross multiple RSpec files (for example, have
  # one test suite for each set of related features),
  # you can duplicate this test file to create a new one.
  before(:each) do
    Space.create(id: 1, space_name: 'Makers HQ', description: 'Awesome', image: 'space1_image_url', price_per_night: '100.0', user_id: '1', request_id: '1')
    Space.create(id: 2, space_name: 'Gherkin', description: 'A little corporate', image: 'space2_image_url', price_per_night: '500.0', user_id: '2', request_id: '1')
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
      session_login
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
      session_login
      @response = post('/spaces', id: 3, space_name: 'Gherkin', price_per_night: '500.0', description: 'A little corporate', image: 'space2_image_url', user_id: 1)

      redirect?
      expect(Space.last.space_name).to eq('Gherkin')
      expect(Space.last.description).to eq('A little corporate')
    end

    it 'returns error messages with invalid input' do
      session_login
      @response = post('/spaces', user_id: 1)
    
      responds_ok?
      copy_test('<h1>Please check: </h1>')
      copy_test("Space name can't be blank")
      copy_test("Price per night can't be blank")
      copy_test("Description can't be blank")
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

    it 'Displays a calendar that blocks any date before today' do
      @response = get('/spaces/1')
      
      responds_ok?
      copy_test('Start Date')
      copy_test('End Date')
    end

    it 'Displays dates the space is already booked for' do
      @response = get('/spaces/1')
      responds_ok?
      copy_test('Start Date')
      copy_test('End Date')
      copy_test('2022-10-13 to 2022-10-14')
    end
  end

  context 'POST /spaces/:id' do
    it 'Checks that signed in user can make request' do
      session_login
      @response = post('/spaces/1', id: 1, start_date: '2022/10/12', end_date: '2022/10/19', user_id: 1, space_id: 1)
      redirect?
      expect(Request.last.start_date.to_s).to eq('2022-10-12')
      # expect(Request.last.end_date).to eq("Wed, 19 Oct 2022")
    end

    xit 'returns error messages if the space has been booked' do
      session_login
      @response = post('/spaces/1', id: 3, start_date: '2022/10/12', end_date: '2022/10/19', user_id: 1, space_id: 1)
      redirect?
      copy_test('Sorry, the space is not available. Please choose other dates!')
    end
  end

  private

  def responds_ok?
    expect(@response.status).to eq(200)
  end

  def redirect?
    expect(@response.status).to eq(302)
  end
 
  def copy_test(text)
    expect(@response.body).to include(text)
  end

  def session_login
    post("/login", :email => 'calum@calum.com', :password => 'CalumCalum')
  end
end
