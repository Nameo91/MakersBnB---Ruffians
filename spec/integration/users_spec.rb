require 'spec_helper'
require 'rack/test'
require_relative '../../app'
require 'json'
require_relative '../../lib/user'

RSpec.describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  before :each do
    User.create(
      id: 1,
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

    it 'returns an error message if the user is logged in' do
      session_login
      @response = get('/signup')

      responds_ok?
      copy_test("You are already Logged in - you can't sign up or login again!")
    end
  end

  context 'POST /signup' do
    it 'should creates a new user record' do
      response = post('/signup',
                      first_name: 'Narae',
                      last_name: 'Kim',
                      username: 'nana',
                      email: 'narae41@hotmail.com',
                      mobile_number: '111111456711',
                      password: 'abcde12345',
                      password_confirmation: 'abcde12345')

      expect(response.status).to eq(302)
      expect(User.last.first_name).to eq('Narae')
      expect(User.last.email).to eq('narae41@hotmail.com')
    end

    it 'should display error messages with invaild input' do
      @response = post('/signup')

      responds_ok?
      copy_test("Password can't be blank")
      copy_test("First name can't be blank")
      copy_test('Password is too short (minimum is 8 characters)')
    end
  end

  context 'GET /login' do
    it 'should display login page with form' do
      @response = get('/login')

      responds_ok?
      copy_test('<h1> Login </h1>')
      copy_test("<form action='/login' method='POST' novalidate>")
      copy_test("<input type='email' name='email' value= 'example@email.com'>")
      copy_test("<input type='password' name='password'>")
    end
  end

  context 'POST /login' do
    it 'should let user log in session' do
      @response = post('/login',
                       email: 'calum@calum.com',
                       password: 'CalumCalum')

      expect(@response.status).to eq(302)
    end

    it 'returns error messages when the user fails to log in' do
      @response = post('/login')

      responds_ok?
      copy_test('Please check your email or password')
    end
  end

  private

  def responds_ok?
    expect(@response.status).to eq(200)
  end

  def copy_test(text)
    expect(@response.body).to include(text)
  end

  def session_login
    post('/login', email: 'calum@calum.com', password: 'CalumCalum')
  end
end
