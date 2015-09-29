class Band < ActiveRecord::Base
  has_many :contracts
  has_many :members, :class_name => "User", :through => :contracts
  
  accepts_nested_attributes_for :contracts
  
  def contract_attributes=(contract_attributes)
    contract_attributes.each do |attributes|
      contract.build(attributes)
    end
  end
end
