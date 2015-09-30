class Band < ActiveRecord::Base
  has_many :contracts
  has_many :members, :class_name => "User", :through => :contracts, :source => :user
  has_one :setlist
  
  validates :name, presence: true
  
  accepts_nested_attributes_for :contracts
  
  def contract_attributes=(contract_attributes)
    contract_attributes.each do |attributes|
      contracts.build(attributes)
    end
  end
end
