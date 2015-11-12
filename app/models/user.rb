class User < ActiveRecord::Base
  audited
  has_many :contracts
  has_many :bands, :through => :contracts

  def self.from_omniauth(auth)
    if auth.provider == "facebook"
      where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.picture_url = auth.info.image
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save!
      end
    else
      where(provider: auth.provider, uid: auth.uri).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uri
        user.name = auth.info.display_name
        puts auth.info.to_hash
        user.picture_url = auth.info.images.first.url
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save!
    end
      
    end
  end
  
  def first_name
    self.name.split(' ')[0]
  end
end