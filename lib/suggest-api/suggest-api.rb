require 'ruby-tmdb'

class SuggestAPI < Sinatra::Base
  Tmdb.api_key = 'fe9ede48826e4591ed8832954f299849'
  Tmdb.default_language = 'en'

  before do
    content_type :json
  end
  
  get "/:term" do |term|
    movies = TmdbMovie.find(:title => term, :limit => 5, :expand_results => false)
    # If movies isn't an array (happens when only one element is returned), make it an array
    movies = [ movies ] if movies.respond_to? :name

    movies.keep_if { |m| m.popularity >= 0.1 and (!m.adult) }
    movies.map! { |m| {:id => m.id, :title => m.name, :release => m.released, :poster => m.posters[0].url, :popularity => m.popularity, :imdb => m.imdb_id } }

    movies.to_json
  end
end
