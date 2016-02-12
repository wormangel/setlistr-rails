class User < ActiveRecord::Base
  audited
  has_many :contracts
  has_many :bands, :through => :contracts

  def self.from_omniauth(auth)
    if auth.provider == "facebook"
      where(fb_uid: auth.uid).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.fb_uid = auth.uid
        user.name = auth.info.name
        user.picture_url = auth.info.image
        user.fb_oauth_token = auth.credentials.token
        user.fb_oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save!
      end
    else
      where(spotify_uri: auth.info.uri).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.spotify_uri = auth.info.uri
        user.name = auth.info.display_name
        user.picture_url = auth.info.images.first.url
        user.spotify_oauth_token = auth.credentials.token
        user.spotify_oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save!
      end
    end
  end
  
  def add_omniauth_provider(auth)
    if auth.provider == "facebook"
      #self.provider = auth.provider TODO decide what to do here
      self.fb_uid = auth.uid
      self.fb_oauth_token = auth.credentials.token
      self.fb_oauth_expires_at = Time.at(auth.credentials.expires_at)
      self.save!
    else
      #self.provider = auth.provider
      self.spotify_uri = auth.info.uri
      self.spotify_oauth_token = auth.credentials.token
      self.spotify_oauth_expires_at = Time.at(auth.credentials.expires_at)
      self.save!
    end
  end
  
  def first_name
    self.name.split(' ')[0]
  end
  
  def next_concerts
    col = []
    bands.each do |band|
      col << band.next_concerts.to_a
    end
    col.flatten.sort_by &:date
  end

  def is_spotify_user
    !self.spotify_oauth_token.nil?
  end
end