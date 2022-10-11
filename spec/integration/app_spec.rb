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
    Space.create(space_name: 'Makers HQ', description: 'Awesome', price_per_night: '100.0', user_id: '1', request_id: '1')
    Space.create(space_name: 'The Gherkin', description: 'A little corporate', price_per_night: '500.0', user_id: '2', request_id: '2')
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
      copy_test('<h1>Check out all spaces</h1>')
      copy_test('Makers HQ')
      copy_test('£100.0')
      copy_test('Awesome')
      copy_test('The Gherkin')
      copy_test('£500.0')
      copy_test('A little corporate')
    end
  end

  context 'GET /spaces/new' do
    xit 'returns an html form to add a new space' do
      @response = get('/spaces/new')

      responds_ok?
      copy_test('<form method="POST" action="/spaces">')
      copy_test('<input type="text" name="space_name">')
      copy_test('<input type="text" name="price_per_night">')
      copy_test('<input type="text" name="description">')
      # copy_test('<select name="user_id">')
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
