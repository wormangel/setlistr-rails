class Concert < ActiveRecord::Base
  audited
  belongs_to :band
  has_one :setlist
  
  mount_uploader :flyer, FlyerUploader
  
  validates :name, :date, :time, presence: true
  
  PAYMENT_TYPE = Enum.new ([
       [:fixedpay, "Fixed Pay"],
       [:boxoffice, "Tickets Sold %"]
  ])
end
