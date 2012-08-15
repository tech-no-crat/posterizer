Sidekiq::Web.use(Rack::Auth::Basic) { |user, password|  password == Rails.configuration.http_auth_password }
