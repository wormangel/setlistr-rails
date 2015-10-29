class SetlistSong < ActiveRecord::Base
  audited
  belongs_to :song
  belongs_to :setlist
end
