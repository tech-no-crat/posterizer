
class PostersController < ApplicationController
  before_filter :require_login
  respond_to :json

  def create
    @movie = Movie.from_cache(params[:ref])
    @poster = Poster.new(:order => params[:order], :movie_id => @movie.id, :user_id => current_user.id)
    if @poster.save
      render :json => {}, status: 201
    else
      render :json => {:error => "Invalid resource"}, status: 400
    end
  end

  def destroy
    Poster.delete(params[:id])
    render :json => {}, status: 201
  end

  private

  def require_login
    redirect_to root_url, :notice => "Sorry, you're not authorized to do that!" unless current_user
  end
end
