class Movie < ActiveRecord::Base
  attr_accessible :release, :title, :tmdb_id, :url
  validates :release, :numericality => {:only_integer => true, :greater_than =>  1000}, :allow_nil => true
  validates :url, :presence => true, :format => { :with => /http:\/\/.*/ }
  validates :title, :presence => true, :length => {:maximum => 240}
  validates :tmdb_id, :presence => true, :length => {:maximum => 200}
  has_many :posters

  scope :most_popular,
    select("movies.title, count(posters.id) AS posters_count").
    joins(:posters).
    order("posters_count DESC").
    limit(10)
  

  def self.from_cache(ref)
    info = CACHE.get ref
    return nil unless info
    movie = Movie.find_by_tmdb_id info[:id]
    unless movie
      movie = Movie.new(:tmdb_id => info[:id], :title => info[:title], :release => info[:release], :url => info[:img])
      return nil unless movie.save
    end
    movie
  end
end
