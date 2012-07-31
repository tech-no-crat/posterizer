
class UsersController < ApplicationController
  layout 'pages'

  def new
    unless session[:auth]
      redirect_to :root_url, :notice => "Sorry, something went wrong while processing your registration."
    end

    @user = User.new
    @auth = session[:auth]
  end

  def create
  end

  def destroy
  end

  def update
  end

  def edit
  end
end
