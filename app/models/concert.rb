class Concert < ActiveRecord::Base
  audited
  belongs_to :band
end
