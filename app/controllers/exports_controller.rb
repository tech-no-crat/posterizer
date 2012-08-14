
class ExportsController < ApplicationController
  before_filter :require_login

  def create
    if current_user.export and ((Time.now - current_user.export.created_at)/ 1.hour).floor < 2
      render :json => {:error => "You can export your posterwall only once every 2 hours. Try again in #{((2.hours - (Time.now - current_user.export.created_at))/60).ceil}"}, :status => 429
      return
    end

    current_user.export.destroy if current_user.export 
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
