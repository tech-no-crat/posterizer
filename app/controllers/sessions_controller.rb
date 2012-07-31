class SessionsController < ApplicationController
  def create
    redirect_to root_url, notice: "Sorry, something went wrong!" unless env["omniauth.auth"]
    auth = env["omniauth.auth"]
    u = User.find_by_omniauth(auth)
    if not u
      # User does not exist yet, go to the new user form
      session[:auth] = auth
      redirect_to new_user_path()
    else
      # User exists, let's log him in
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end

