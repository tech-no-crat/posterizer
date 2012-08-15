require 'sinatra'
require 'ruby-tmdb'
require 'securerandom'

class SuggestAPI < Sinatra::Base
  Tmdb.api_key = 'fe9ede48826e4591ed8832954f299849'
  Tmdb.default_language = 'en'

  before do
    content_type :json
  end
  
  @@preferred_poster_size = 'mid'
  def generate_cache_key
    key = ''
    begin
      key = SecureRandom.hex 16
    end while CACHE.get key
    key
  end

  def choose_poster(posters)
    chosen_one = nil
    posters.each do |poster|
      chosen_one = poster if poster.size == @@preferred_poster_size
    end

    chosen_one = posters.first unless chosen_one
    chosen_one
  end

  def cache_get(term)
    key = "suggest-cache.#{term}" 
    CACHE.get key
  end

  def cache_set(term, value)
    key = "suggest-cache.#{term}" 
    CACHE.set key, value, 10.minutes
  end

  get "/:term" do |term|
    cached = cache_get(term)
    return cached if cached

    movies = TmdbMovie.find(:title => term, :limit => 5, :expand_results => false)
    # If movies isn't an array (happens when only one element is returned), make it an array
    movies = [ movies ] if movies.respond_to? :name

    movies.keep_if { |m| m.popularity >= 0.1 and (!m.adult) }
    movies.map! do |m|
      poster = choose_poster(m.posters)
      h = {:id => m.id, :title => m.name, :popularity => m.popularity, :imdb => m.imdb_id}
      h[:img] = poster.url if m.posters.length > 0
      h[:release] = m.released[0,4] if m.released
      h
    end
    movies.each do |m|
      cache_key = generate_cache_key
      CACHE.set cache_key, m, 5.hours
      m[:cache_key] = cache_key
    end

    ans = movies.to_json
    cache_set(term, ans)
    ans
  end
end
