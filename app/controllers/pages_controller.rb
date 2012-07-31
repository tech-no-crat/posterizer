
class PagesController < ApplicationController
  def landing
    render :index, :layout => 'landing'
  end
end

