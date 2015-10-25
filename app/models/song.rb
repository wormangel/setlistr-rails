class Song < ActiveRecord::Base

  validates :artist, presence: true
  validates :title, presence: true

  def ==(o)
    o.class == self.class && 
      o.artist == self.artist && 
      o.title == self.title
  end
end
