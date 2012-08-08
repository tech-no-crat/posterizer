# Load the rails application
require File.expand_path('../application', __FILE__)
require 'memcache'

# Initialize the rails application
Posterizer::Application.initialize!

CACHE = MemCache.new('127.0.0.1')
