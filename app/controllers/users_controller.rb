
class UsersController < ApplicationController
  layout 'pages'
  before_filter :require_oauth_from_session, :only => [:new, :create]
  before_filter :require_correct_user, :only => [:edit]

  @@poster_width = 180

  def new
    @user = User.new
  end

  def create
    params[:user] ||= {}
    @user = User.new(params[:user].merge(:provider => @auth['provider'], :uid => @auth['uid']))
    if @user.save
      flash[:success] = "Welcome to Posterizer, #{@user.name}!"
      redirect_to :controller => 'sessions', :action => 'create', :id => @user.id
    else
      render 'new'
    end
  end

  def show
    @user = User.find_by_handle(params[:handle])
    unless @user
      redirect_to root_url, :notice => "User not found!"
      return
    end
    render :show, :layout => 'posterwall'
  end

  def edit
    @user = User.find_by_handle(params[:id])
    unless @user
      redirect_to root_url, :notice => "User not found!"
      return
    end
    render :edit, :layout => 'posterwall'
  end

  def destroy
  end

  def update
    @user = current_user
    if @user.handle != params[:handle]
      render :json => {:error => "Not authorized"}, :status => 401 
      return
    end

    @user.poster_width = params[:user][:poster_width]
    if @user.save
      render :json => {}, :status => 200
    else
      render :json => {:error => "Invalid Resource"}, :status => 400 
    end
  end

  def request_export
    ExportPosterwall.perform_async(current_user.id) if current_user
  end

  private

  def require_oauth_from_session
    redirect_to root_url, :notice => "Sorry, something went wrong while processing your registration." unless session[:auth]
    @auth = session[:auth]
  end

  def require_correct_user
    user_handle = ''
    user_handle = current_user.handle if current_user
    redirect_to root_url, :notice => "Sorry, you're not authorized to do that!" unless user_handle == params[:id]
  end
end
