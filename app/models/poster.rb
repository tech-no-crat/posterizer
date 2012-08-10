class Poster < ActiveRecord::Base
  attr_accessible :movie_id, :user_id, :order
  belongs_to :movie
  belongs_to :user

  validates :order, :presence => true, :numericality => {:only_integer => true, :greater_than =>  0}
  validates_presence_of :user
  validates_presence_of :movie
  
end
