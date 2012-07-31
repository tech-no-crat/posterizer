OmniAuth.config.logger = Rails.logger

facebook_key = '476665912360822'
facebook_secret = 'da716d424d4e703bcaa889798ef33fa4'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, facebook_key, facebook_secret
end

