
class PostersController < ApplicationController
  before_filter :require_login
  respond_to :json

  def create
    params[:poster] ||= {}
    params[:poster].merge!({:user_id => current_user.id})
    @poster = Poster.new params[:poster]
    if @poster.save
      render :json => {}, status: 201
    else
      render :json => {:error => "Invalid resource"}, status: 400
    end
  end

  def destroy
  end

  private

  def require_login
    redirect_to root_url, :notice => "Sorry, you're not authorized to do that!" unless current_user
  end
end
