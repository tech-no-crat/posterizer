
class PagesController < ApplicationController
  def landing
    render :index, :layout => 'landing'
  end


  def about
    render :about, :layout => 'pages'
  end

  def terms
    render :terms, :layout => 'pages'
  end
end

