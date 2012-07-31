require "spec_helper"

describe User do
  before :each do
    @attr = {:handle => 'test_user', :name => 'Test User', :provider => 'facebook', :uid => 'testuser001'}
    @auth = {'uid' => @attr[:uid], 'provider' => @attr[:provider], 'info' => {'name' => @attr[:name]} }
  end

  describe "validations" do
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

  describe ".find_by_omniauth" do
    it "should find a user given his provider and uid" do
      user = User.create(@attr)
      User.find_by_omniauth(@auth).should == user
    end

    it "should return nil when finding non-existing users" do
      User.find_by_omniauth(@auth).should be_nil
    end

    it "should not confuse users with same uids but different providers" do
      user_f = User.create(@attr)
      user_t = User.create(@attr.merge(:provider => 'twitter'))
      User.find_by_omniauth(@auth).should == user_f
      User.find_by_omniauth(@auth.merge('provider' => 'twitter')).should == user_t
    end

    it "should not confuse users with same providers but different uids" do
      uid2 = @attr[:uid] + 'a'
      user1 = User.create(@attr)
      user2 = User.create(@attr.merge(:uid => uid2))
      User.find_by_omniauth(@auth).should == user1
      User.find_by_omniauth(@auth.merge('uid' => uid2)).should == user2

    end
  end

  describe ".new_from_omniauth" do
    it "should create a new user instance with the correct attributes" do
      User.should_receive(:new).with(:uid => @attr[:uid], :provider => @attr[:provider])
      User.new_from_omniauth(@auth)
    end
  end

  describe ".from_omniauth" do
    it "should check whether the user already exists" do
      User.should_receive(:find_by_omniauth).with(@auth)
      User.from_omniauth(@auth)
    end

    it "should try creating a user if the given attributes are new" do
      User.stub(:find_by_omniauth) { nil }
      User.should_receive(:new_from_omniauth).with(@auth)
      User.from_omniauth(@auth)
    end
      
    it "should return the new user if the attributes are new" do
      user = User.new(@attr)
      User.stub(:find_by_omniauth) { nil }
      User.stub(:new_from_omniauth) { user } 
      User.from_omniauth(@auth).should == user
    end

    it "should return the existing user if the user exists" do
      user = User.new(@attr)
      User.stub(:find_by_omniauth) { user }
      User.from_omniauth(@auth).should == user
    end
  end
end

