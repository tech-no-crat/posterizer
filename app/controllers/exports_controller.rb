
class ExportsController < ApplicationController
  before_filter :require_login
  include ActionView::Helpers::DateHelper

  def create
    if current_user.export and ((Time.now - current_user.export.created_at)/ 1.hour).floor < 2
      render :json => {:error => "You can export your posterwall only once every 2 hours. Try again in #{((2.hours - (Time.now - current_user.export.created_at))/60).ceil} minutes!"}, :status => 429
      return
    end

    if current_user.posters.length < 10
      render :json => {:error => "You need at least 10 posters in your posterwall before we can generate an image"}, :status => 400
      return
    end

    width = height = 0
    begin
      width = params[:width].to_i
      height = params[:height].to_i
    rescue NoMethodError
      render :json => {:error => "Invalid height/width paramers"}, :status => 400
      return
    end

    if width < 10 or width > 3000 or height  < 10 or height > 3000
      render :json => {:error => "Request height and width must be in the 10..3000 range"}, :status => 400
      return
    end

    current_user.export.destroy if current_user.export 
    export = current_user.build_export
    export.save
    ExportPosterwall.perform_async(export.id, width, height)
    render :json => {}, :status => 269 # HTTP 269, Callback Later
  end

  def show
    user = User.find_by_handle(params[:handle])
    export = user.export
    if export
      render :json => {:found => true, :id => export.id, :path => export.path, :status => export.status, :time_ago => time_ago_in_words(export.created_at)}, :status => 200
    else
      # Should return 404, but most browsers raise an uncatchable error for non 2XX replies
      render :json => {:found => false}, :status => 200
    end
  end

  private

  def require_login
    redirect_to root_url, :notice => "You are not authorized to do that!" unless current_user
  end
end
