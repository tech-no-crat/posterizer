require 'spec_helper'

describe Export do
  before :each do
    @user = User.create(:handle => 'test_user', :name => 'Test User', :provider => 'facebook', :uid => 'testuser001', :email => "testuser@testworld.com", :poster_width => 100)
  end

  it "user_id should not be accessible" do
    lambda { Export.new(:user_id => 42) }.should raise_error ActiveModel::MassAssignmentSecurity::Error
  end

  it "should be creatable through User.export=" do
    export = @user.build_export 
    export.user_id.should == @user.id
    export.should be_valid
  end
  
  it "should set default values and overwrite parameters" do
    export = @user.build_export(:downloads => 52)
    export.save
    export.downloads.should == 0
    export.path.should be_nil
    export.generated_at.should be_nil
  end

end
