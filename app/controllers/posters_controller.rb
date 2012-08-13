
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
    movie = Movie.find_by_tmdb_id(params[:id])
    poster = Poster.find(:first, :conditions => {:movie_id => movie.id, :user_id => current_user.id})
    unless poster.user_id == current_user.id
      render :json => {}, status: 401
    else
      poster.delete
      render :json => {}, status: 201
    end
  end

  private

  def require_login
    redirect_to root_url, :notice => "Sorry, you're not authorized to do that!" unless current_user
  end
end
