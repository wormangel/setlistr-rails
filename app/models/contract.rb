class Contract < ActiveRecord::Base
  audited
  belongs_to :user
  belongs_to :band
  
  INSTRUMENTS = Enum.new ([ :guitar, :bass, :vocals, :drums, :keyboard ])
end
