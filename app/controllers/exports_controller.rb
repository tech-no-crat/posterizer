
class ExportsController < ApplicationController
  before_filter :require_login

  def create
    export = current_user.build_export
    export.save
    ExportPosterwall.perform_async(export.id)
    render :json => {}, :status => 269 # HTTP 269, Callback Later
  end

  def show
  end

  def download
  end

  private
  
  def require_login
    redirect_to root_url, :notice => "You are not authorized to do that!" unless current_user
  end
end
