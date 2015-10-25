class Song < ActiveRecord::Base

  validates :artist, presence: true
  validates :title, presence: true

  def ==(o)
    o.class == self.class && 
      o.artist == self.artist && 
      o.title == self.title
  end
  
  def self.get_or_create(song_params)
    if Song.exists?(song_params)
      song = Song.where(song_params).first
    else
      song = Song.create(song_params)
    end
    song
  end
end
