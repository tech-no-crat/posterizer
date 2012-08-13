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
      user = mock_model(User)
      export = mock_model(Export, :save => true)
      controller.stub(:current_user) { user }
      user.should_receive(:build_export) { export }
      export.should_receive(:save)
      post 'create'
    end

    it "should call perform_async on the sidekiq ExportPosterwall poster with the correct export  id" do
      user = mock_model(User)
      export = mock_model(Export, :id => 42, :save => true)
      controller.stub(:current_user) { user }
      user.stub(:build_export) { export }
      ExportPosterwall.should_receive(:perform_async).with(export.id)
      post 'create'
    end
  end

end
