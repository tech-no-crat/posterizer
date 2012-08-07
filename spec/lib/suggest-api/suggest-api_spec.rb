require "spec_helper"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

describe SuggestAPI do
  def app
    SuggestAPI
  end

  before :each do
    @term = 'potato'
    TmdbMovie.stub(:find) { []}
  end

  it 'should return status code 200 OK' do
    get '/test'
    last_response.status.should == 200
  end

  it 'should return valid json' do
    get "/#{@term}"
    last_response.body.should be_valid_json
  end
end
