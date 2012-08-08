class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def data_cache(key)
    unless output = CACHE.get(key)
      output = yield
      CACHE.set(key, output, 1.hour)
    end
    return output
  end
end
