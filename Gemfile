source 'https://rubygems.org'

gem 'rails', '3.2.5'
gem 'sinatra', '1.2.6', :require => nil
gem 'ruby-tmdb'
gem 'memcache-client'
gem 'rmagick', :require => 'RMagick'

gem 'activeadmin'
gem "meta_search",    '>= 1.1.0.pre'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'omniauth', :git => 'git://github.com/intridea/omniauth.git' #Latest and greatest
gem 'omniauth-facebook'

gem 'sidekiq', '2.0.3'
gem 'slim'

gem 'newrelic_rpm'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'haml-rails'
  gem 'maruku'
  gem 'jquery-ui-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :production do
 gem 'therubyracer'
 gem 'execjs'
 gem 'mysql2'
 #gem 'activerecord-mysql2-adapter'
end

group :development do
  gem 'autorefresh'
  gem 'capistrano-unicorn', :require => false
end

group :test, :development do
  gem "webrat"
  gem "rspec-rails"
  gem "rack-test"
end

gem 'simplecov', :require => false, :group => :test

gem 'jquery-rails'


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

gem 'thin'

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano'

# To use debugger
# gem 'debugger'
