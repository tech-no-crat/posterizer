require 'yaml'
OmniAuth.config.logger = Rails.logger

app_id = Rails.configuration.secrets['facebook']['app_id']
app_secret = Rails.configuration.secrets['facebook']['app_secret']

# If we're in development, use the development-specific API keys
if Rails.env == 'development'
  app_id = Rails.configuration.secrets['facebook']['development']['app_id']
  app_secret = Rails.configuration.secrets['facebook']['development']['app_secret']
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, app_id, app_secret
end

