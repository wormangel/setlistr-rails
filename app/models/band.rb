class Band < ActiveRecord::Base
  has_many :contracts
  has_many :members, :class_name => "User", :through => :contracts, :source => :user
  has_one :setlist
  
  validates :name, presence: true
  
  before_create do
    self.setlist = Setlist.create
  end
  
  accepts_nested_attributes_for :contracts
  
  def contract_attributes=(contract_attributes)
    contract_attributes.each do |attributes|
      contracts.build(attributes)
    end
  end
  
  def invite_token
    puts Rails.application.config.invite_salt
    hashids = Hashids.new Rails.application.config.invite_salt
    
    return hashids.encode(self.id)
  end
end
