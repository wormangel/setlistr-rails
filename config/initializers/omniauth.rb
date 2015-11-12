require 'rspotify/oauth'

OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['SETLISTR_FB_APP_ID'], ENV['SETLISTR_FB_APP_SECRET'],
           :callback_url => ENV['SETLISTR_FB_REDIRECT_URL']
  provider :spotify, ENV['SETLISTR_SPOTIFY_ID'], ENV['SETLISTR_SPOTIFY_SECRET'], 
            scope: 'playlist-read-private playlist-read-collaborative playlist-modify-public playlist-modify-private user-read-private'
end

