require 'spec_helper'

describe ExportsController do
  describe "POST 'create'" do
    it "should redirect to root_url if the user is not logged in" do
      controller.stub(:current_user) { nil }
      controller.should_receive(:current_user)
      post 'create'
      response.should redirect_to root_url
    end

    it "should create an export model for the current user, and give status 269" do
      user = mock_model(User, :export => nil)
      export = mock_model(Export, :save => true)
      controller.stub(:current_user) { user }
      user.should_receive(:build_export) { export }
      export.should_receive(:save)
      post 'create'
    end

    it "should call perform_async on the sidekiq ExportPosterwall poster with the correct export  id" do
      user = mock_model(User, :export => nil)
      export = mock_model(Export, :id => 42, :save => true)
      controller.stub(:current_user) { user }
      user.stub(:build_export) { export }
      ExportPosterwall.should_receive(:perform_async).with(export.id)
      post 'create'
    end

    it "should return status 429 instead of creating a new export if the user created an export request less than two hours ago" do
      export = mock_model(Export, :created_at => Time.now - 1.hour)
      user = mock_model(User, :export => export)
      controller.stub(:current_user) { user }
      user.should_not_receive(:build_export)
      post 'create'
      response.response_code.should == 429
    end
  end

end
