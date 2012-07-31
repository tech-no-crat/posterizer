
class UsersController < ApplicationController
  layout 'pages'
  before_filter :require_oauth_from_session, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    params[:user] ||= {}
    @user = User.new(params[:user].merge(:provider => @auth['provider'], :uid => @auth['uid']))
    if @user.save
      flash[:success] = "Welcome to Posterizer, #{@user.name}!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
  end

  def update
  end

  def edit
  end

  def view
  end

  private

  def require_oauth_from_session
    redirect_to root_url, :notice => "Sorry, something went wrong while processing your registration." unless session[:auth]
    @auth = session[:auth]
  end
end
