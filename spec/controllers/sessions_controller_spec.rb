require "spec_helper"

describe SessionsController do
  before :each do
    @auth = OmniAuth.config.mock_auth[:facebook]
    request.env['omniauth.auth'] = @auth
  end

  describe ".create" do
    it "should redirect to root_url if env['omniauth.auth'] is not set" do
      request.env['omniauth.auth'] = nil
      post :create
      response.should redirect_to root_url
    end

    it "should attempt to find a user by omniauth" do
      User.should_receive(:find_by_omniauth).with(@auth)
      post :create
    end

    it "should set session[:auth] and redirect to new_user_path if the user does not exist" do
      User.stub(:find_by_omniauth) { nil }
      post :create
      session[:auth].should == @auth
      response.should redirect_to new_user_path
    end
    
    it "should login the user: set session[:user_id] and redirect to user view if the user exists" do
      user = User.new(:name => "Test User")
      user.id = 42
      User.stub(:find_by_omniauth) { user }
      post :create
      session[:user_id].should == user.id
      response.should redirect_to user
    end
  end
end
