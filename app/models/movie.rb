class Movie < ActiveRecord::Base
  attr_accessible :release, :title, :tmdb_id
  has_many :posters
end
