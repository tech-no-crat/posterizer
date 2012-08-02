require "spec_helper"

describe ApplicationController do
  
  controller do
    def cur_user
      current_user
    end
  end

  # Testing an important private method here
  describe ".current_user" do
    it "returns nil if session[:user_id] is not set" do
      session[:user_id] = nil
      controller.cur_user.should be nil
    end

    it "searches for the user with id = session[:user_id] if session[:user_id] is set" do
      session[:user_id] = 42
      User.should_receive(:find_by_id).with(42)
      controller.cur_user.should be nil
    end

    it "returns and assigns the requested user if session[:user_id] is set" do
      session[:user_id] = 42
      user = User.new(:name => "Test User")
      User.stub(:find_by_id) { user }
      controller.cur_user.should == user
    end
  end
end
