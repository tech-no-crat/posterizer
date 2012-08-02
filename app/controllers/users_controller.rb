
class UsersController < ApplicationController
  layout 'pages'
  before_filter :require_oauth_from_session, :only => [:new, :create]
  before_filter :require_correct_user, :only => [:edit, :update]

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

  def show
    @user = User.find_by_id(params[:id].to_i)
    unless @user
      redirect_to root_url, :notice => "User not found!"
      return
    end
    render :show, :layout => 'posterwall'
  end

  def edit
    @user = User.find_by_id(params[:id].to_i)
    unless @user
      redirect_to root_url, :notice => "User not found!"
      return
    end
    render :edit, :layout => 'posterwall'
  end

  def destroy
  end

  def update
  end

  private

  def require_oauth_from_session
    redirect_to root_url, :notice => "Sorry, something went wrong while processing your registration." unless session[:auth]
    @auth = session[:auth]
  end

  def require_correct_user
    user_id = 0
    user_id = current_user.id if current_user
    redirect_to root_url, :notice => "Sorry, you're not authorized to do that!" unless (current_user ? current_user.id : 0) == params[:id].to_i
  end
end
