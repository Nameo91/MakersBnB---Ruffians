require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'
require_relative '../../lib/user.rb'

RSpec.describe Application do
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
    user = User.create(
      first_name: 'Calum', 
      last_name: 'Wilmot', 
      username: 'Cal', 
      email: 'calum@calum.com', 
      mobile_number: '11111111111', 
      password: 'CalumCalum', 
      password_confirmation: 'CalumCalum'
    )
  end

  context 'GET /signup' do
    it 'should display signup page to get new user information' do
      @response = get('/signup')

      responds_ok?
      copy_test("<form action='/signup' method='POST' novalidate>")
      copy_test("<input type='string' name = 'first_name'>")
      copy_test("<input type='string' name = 'last_name'>")
      copy_test("<input type='string' name = 'username'>")
      copy_test("<input type='string' name = 'mobile_number'>")
      copy_test("<input type='email' name='email' value= 'example@email.com'>")
      copy_test("<input type='password' name='password'>")
      copy_test("<input type='password' name='password_confirmation'>")
      copy_test("<input type='submit' value='Signup'>")
    end
  end

  context 'POST /signup' do
    it 'should creates a new user record' do
      @response = post('/signup')
      new_user = User.create(
        first_name: 'Narae', 
        last_name: 'Kim', 
        username: 'nana', 
        email: 'narae41@hotmail.com', 
        mobile_number: '111111456711', 
        password: 'abcde12345',
        password_confirmation: 'abcde12345')

      responds_ok?
      expect(new_user.save).to eq true
    end

    it 'should display error messages' do
      @response = post('/signup')

      new_user = User.create()
      responds_ok?
      expect(new_user.save).to eq false
      copy_test("Password can't be blank")
      copy_test("First name can't be blank")
      copy_test("Password is too short (minimum is 8 characters)")    
    end
  end

  context 'GET /login' do
    it 'should display login page with form' do
      @response = get('/login')

      responds_ok?
      copy_test("<h1> Login </h1>")
      copy_test("<form action='/login' method='POST' novalidate>")
      copy_test("<input type='email' name='email' value= 'example@email.com'>")
      copy_test("<input type='password' name='password'>")
    end
  end

  context 'POST /login' do
    it 'should let user log in session' do
      @response = post('/login')
      user = User.find_by_email('calum@calum.com')
      
      expect(user.first_name).to eq ('Calum')
      responds_ok?   
    end

    it 'returns error messages when the user fails to log in' do
      @response = post('/login')

      responds_ok?
      copy_test("Please check your email or password")
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