require 'spec_helper'

describe Poster do
  before :each do
    @u = User.create(:handle => 'test_user', :name => 'Test User', :provider => 'facebook', :uid => 'testuser001', :email => "testuser@testworld.com")
    @m = Movie.create(:title => "my movie", :release => 1996, :tmdb_id => "hello", :url => "http://test.com/img/image.png") 
    @params = {:movie_id => @m.id, :user_id => @u.id, :order => 6}
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

    it "should require a user_id" do
      poster = Poster.new(@params.merge(:user_id => nil))
      poster.should_not be_valid
    end

    it "should require a movie_id" do
      poster = Poster.new(@params.merge(:movie_id => nil))
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

    it "should reject posters that belong to non-existing users" do
      poster = Poster.new(@params.merge(:user_id => @u.id + 1))
      poster.should_not be_valid
    end

    it "should reject posters that belong to non-existing movies" do
      poster = Poster.new(@params.merge(:movie_id => @m.id + 1))
      poster.should_not be_valid
    end
  end
end
