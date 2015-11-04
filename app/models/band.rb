class Band < ActiveRecord::Base
  audited
  has_many :contracts
  has_many :members, :class_name => "User", :through => :contracts, :source => :user
  has_many :setlists
  has_many :concerts
  has_many :songs
  
  mount_uploader :logo, LogoUploader
  
  validates :name, presence: true
  
  before_create do
    self.setlists << Setlist.create(master: true)
  end
  
  def setlist
    self.setlists.where(master: true).first
  end
  
  def next_concerts
    self.concerts.where("date > ?", DateTime.now).order("date asc")
  end
  
  def past_concerts
    self.concerts.where("date < ?", DateTime.now).order("date desc")
  end
  
  def has_songs_with_missing_info
    # TODO should return true if any of its songs returns true for missing_crawlable_media
    
    # test result 
    true
  end
  
  accepts_nested_attributes_for :contracts
  
  def contract_attributes=(contract_attributes)
    contract_attributes.each do |attributes|
      contracts.build(attributes)
    end
  end
  
  def active_members
    self.members.where(:contracts=> {:approved => true})
  end
  
  def invite_token
    hashids = Hashids.new Rails.application.config.invite_salt
    
    hashids.encode(self.id)
  end
  
  def self.from_invite_token(token)
    hashids = Hashids.new Rails.application.config.invite_salt
    
    Band.find(hashids.decode(token).first)
  end
end
