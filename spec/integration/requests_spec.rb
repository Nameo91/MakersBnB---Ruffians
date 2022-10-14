require "spec_helper"
require "rack/test"
require_relative '../../app'
require 'json'
require_relative '../../lib/user.rb'

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

    before(:each) do
    Space.create(id: 1,
      space_name: 'Makers HQ',
      description: 'Awesome',
      image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQup-GHifQfwYZRp7tVpByvyVxckoexLyIbNg&usqp=CAU",
      price_per_night: '100.0',
      user_id: '1',
      request_id: '1'
    )
    Space.create(id: 2,
      space_name: 'Gherkin',
      description: 'A little corporate',
      image: "https://assets.big-cottages.com/assets/home/hp-hero-1_m-0b1c4c41fc7b3d547fff14e3cc386f59a56f37688d9feca829564e7a51548554.jpg",
      price_per_night: '500.0',
      user_id: '2',
      request_id: '1'
    )
    Request.create(id: 1, start_date: '2022-10-13', end_date: '2022-10-14', space_id: '1', user_id: '1')
    Request.create(id: 2, start_date: '2022-10-15', end_date: '2022-10-16', space_id: '1', user_id: '2')
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
    User.create(
      id: 2,  
      first_name: 'tom', 
      last_name: 'allen', 
      username: 'tom', 
      email: 'tom@tom.com', 
      mobile_number: '11111111112', 
      password: 'TomTom', 
      password_confirmation: 'TomTom'
    )
  end

  context 'POST /spaces/:id' do 
    it 'Creates a new date request' do
      post("/login", :email => 'calum@calum.com', :password => 'CalumCalum')
      @response = post('/spaces/1', id:3, start_date: '2022/10/12', end_date: '2022/10/19', user_id: 1, space_id: 1)
      
      expect(@response.status).to eq(302)
      expect(Request.last.start_date.to_s).to eq('2022-10-12')
    end
  end

  context 'POST /spaces/:id' do
    it 'approves request and updates calendar instantly when made by the space owner' do
      post("/login", :email => 'calum@calum.com', :password => 'CalumCalum')
      @response = post('/spaces/1', start_date: '2022/10/12', end_date: '2022/10/19', user_id: 1, space_id: 1)

      expect(@response.status).to eq(302)
      expect(Request.last.approval_status).to eq true
    end

    it 'request will be pending when made by a user other than the space owner' do
      post("/login", :email => 'tom@tom.com', :password => 'TomTom')
      @response = post('/spaces/1', start_date: '2022/10/12', end_date: '2022/10/19', user_id: 2, space_id: 1)

      expect(@response.status).to eq(302)
      expect(Request.last.approval_status).to eq nil
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