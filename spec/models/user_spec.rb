require "spec_helper"

describe User do
  before :each do
    @attr = {:handle => 'test_user', :name => 'Test User', :provider => 'facebook', :uid => 'testuser001'}
  end

  it "should create a instance given valid parameters" do
    user = User.new @attr
    user.should be_valid
  end

  it "should require a name" do
    user = User.new(@attr.merge(:name => ""))
    user.should_not be_valid
  end

  it "should reject very long names" do
    user = User.new(@attr.merge(:name => ("a" * 51)))
    user.should_not be_valid
  end

  it "should reject very short names" do
    user = User.new(@attr.merge(:name => "x"))
    user.should_not be_valid
  end

  it "should require a handle" do
    user = User.new(@attr.merge(:handle => ""))
    user.should_not be_valid
  end

  it "should reject invalid handles" do
    user = User.new(@attr.merge(:handle => "two words"))
    user.should_not be_valid
  end

  it "should reject very long handles" do
    user = User.new(@attr.merge(:handle => "a" * 51))
    user.should_not be_valid
  end

  it "should reject very short handles" do
    user = User.new(@attr.merge(:handle => "a"))
    user.should_not be_valid
  end
  
  it "should require a provider" do
    user = User.new(@attr.merge(:provider => ""))
    user.should_not be_valid
  end

  it "should reject extremly long providers" do
      user = User.new(@attr.merge(:provider => "a" * 500))
      user.should_not be_valid
  end

  it "should require a uid" do
    user = User.new(@attr.merge(:uid => ""))
    user.should_not be_valid
  end

  it "should reject extremely long uids" do
    user = User.new(@attr.merge(:uid => "a" * 500))
  end
end

