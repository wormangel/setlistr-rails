class Contract < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :band
  
  INSTRUMENTS = Enum.new ([
       [:guitar, "Guitar"],
       [:bass, "Bass"],
       [:vocals, "Vocals"],
       [:drums, "Drums"],
       [:keyboard, "Keyboard"]
       ])
end
