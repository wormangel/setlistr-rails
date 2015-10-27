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
    base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    cipher = "UCHAMhyuToiPwqQGr1c6ej48bKI3WYszvXF0LnOt7J2SBpRkadDf5N9EZxVmlg"
    
    return self.name.tr(base, cipher)
  end
end
