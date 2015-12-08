class User < ActiveRecord::Base
  audited
  has_many :contracts
  has_many :bands, :through => :contracts

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.admin = false
      user.save!
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
end
