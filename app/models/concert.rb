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
  
  def update_setlist_after_save(saved_song)
    self.setlist.setlist_songs.where("pos >= ?", saved_song.pos).each do |s|
      if s == saved_song
        next
      end
      
      s.pos += 1
      s.save
    end
  end
  
  def update_setlist_after_destroy(pos)
    self.setlist.setlist_songs.where("pos > ?", pos).each do |s|      
      s.pos -= 1
      s.save
    end
  end
  
  def update_setlist_after_update(saved_song, old_value)
    if saved_song.pos < old_value # If we are moving from a higher position to a lower one (e.g. from 4 to 2)
      self.setlist.setlist_songs.where("pos >= ? and pos < ?", saved_song.pos, old_value).each do |s|
        if s == saved_song
          next
        end
      
        s.pos += 1
        s.save
      end
    else # If we are moving from a lower position to a higher one (e.g. from 2 to 4)
      self.setlist.setlist_songs.where("pos >  ? and pos <= ?", old_value, saved_song.pos).each do |s|
        if s == saved_song
          next
        end
      
        s.pos -= 1
        s.save
      end
    end
  end
end
