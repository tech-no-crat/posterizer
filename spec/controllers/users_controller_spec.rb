require "spec_helper"

describe UsersController do
  before :each do
    @auth = {'provider' => 'facebook', 'uid' => 'a' * 20, 'info' => 
      {
        'nickname' => 'testuser',
        'name' => 'Test User',
        'email' => 'testuser@testuser.com'
      }
    }
    @user = User.new(:name => "Test Bot")
  end

  describe ".new" do
    it "should redirect to root_url if session[:auth] is not set" do
      session[:auth] = nil
      get :new
      response.should redirect_to root_url
    end

    it "should render the correct template if session[:auth] is set" do
      session[:auth] = @auth
      get :new
      response.should render_template("layouts/pages")
      response.should render_template("new")
    end

    it "should assign a user instance if session[:auth] is set" do
      session[:auth] = @auth
      get :new
      assigns(:user).should be_kind_of User
    end
  end

  describe ".create" do
    it "should redirect to root_url if session[:auth] is not set" do
      session[:auth] = nil
      get :new
      response.should redirect_to root_url
    end

    it "should attempt to save a new user with the correct parameters" do
      session[:auth] = @auth
      User.stub(:new) { @user }
      @user.should_receive(:save)
      post :create, :user => {:name => @user.name}
    end

    it "should redirect to sessions/create if the user is valid" do
      session[:auth] = @auth
      user = mock_model(User,:save=>true)
      User.stub(:new) { user }
      post :create, :user => {:name => @user.name}
      response.should redirect_to "/sessions/create?id=#{user.id}" 
    end

    it "should render new if no parameters were given" do
      session[:auth] = @auth
      post :create
      response.should render_template 'new'
    end

    it "should render new if the user is not valid" do
      session[:auth] = @auth
      User.stub(:new) {mock_model(User,:save=>false)}
      post :create, :user => {:name => @user.name}
      response.should render_template 'new'
    end
  end

  describe ".show" do
    it "it should redirect to root_url if :user_id is not passed as a paramater" do
      get :show
      response.should redirect_to root_url
    end

    it "should search for the user" do
      handle = 'testuser'
      User.should_receive(:find_by_handle).with handle
      get :show, :handle => handle
    end

    it "should redirect to root_url if the user was not found" do
      id = 42
      User.stub(:find_by_id) { nil }
      get :show, :id => id
      response.should redirect_to root_url
    end

    it "should render the correct views if the user was found" do
      user = User.new(:name => "Test User")
      User.stub(:find_by_handle) { user }
      get :show
      response.should render_template :show
    end

    it "should assign the correct user if the user exists" do
      user = mock_model(User, :name => "Test User")
      User.stub(:find_by_handle) { user }
      get :show
      assigns(:user).should == user
    end
  end

end
