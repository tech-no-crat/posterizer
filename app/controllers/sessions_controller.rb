class SessionsController < ApplicationController
  def create
    unless request.env["omniauth.auth"] or params[:id]
      redirect_to root_url, notice: "Sorry, something went wrong!"
      return
    end

    auth = request.env["omniauth.auth"]
    if auth
      u = User.find_by_omniauth(auth)
    else
      u = User.find_by_id(params[:id])
    end
    if not u
      # User does not exist yet, go to the new user form
      session[:auth] = auth
      redirect_to new_user_path
    else
      # User exists, let's log him in
      session[:user_id] = u.id
      redirect_to u
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end

