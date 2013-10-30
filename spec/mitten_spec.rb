require_relative '../mitten'
require 'test/unit'
require 'rack/test'

describe 'The Mitten App' do
  include Rack::Test::Methods

  def app
    Mitten
  end

  before :each do
    file = double("File")
    File.stub(:open).and_yield(file)
    file.stub(:puts)
  end

  it "has a test endpoint" do
    get '/test'

    expect(last_response).to be_ok
    expect(last_response.body).to eq('The three little kittens they found their mittens')
  end

end