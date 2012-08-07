require 'spec_helper'

describe Poster do
  before :each do
    @u = User.create(:handle => 'test_user', :name => 'Test User', :provider => 'facebook', :uid => 'testuser001', :email => "testuser@testworld.com")
    @params = {:movie_id => 42, :user_id => @u.id, :order => 6, :url => "http://test.com/image/cutekitty.png"}
  end

  describe "validations" do
    it "should accept a valid poster" do
      poster = Poster.new(@params)
      poster.should be_valid
    end

    it "should require an order" do
      poster = Poster.new(@params.merge(:order => nil))
      poster.should_not be_valid
    end

    it "should require a url" do
      poster = Poster.new(@params.merge(:url => nil))
      poster.should_not be_valid
    end

    it "should require a user_id" do
      poster = Poster.new(@params.merge(:user_id => nil))
      poster.should_not be_valid
    end

    it "should reject negative order numbers" do
      poster = Poster.new(@params.merge(:order => -5))
      poster.should_not be_valid
    end

    it "should reject records with a non-numeric order" do
      poster = Poster.new(@params.merge(:order => "a little blue pony"))
      poster.should_not be_valid
    end

    it "should reject invalid urls" do
      poster = Poster.new(@params.merge(:url => "invalid url"))
      poster.should_not be_valid
    end

    it "should reject posters that belong to non-existing users" do
      poster = Poster.new(@params.merge(:user_id => @u.id + 1))
      poster.should_not be_valid
    end
  end
end
