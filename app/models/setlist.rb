class Setlist < ActiveRecord::Base
  belongs_to :band
  has_many :setlist_songs
  has_many :songs, :class_name => "Song", :through => :setlist_songs
  
  def empty?
    songs.count == 0
  end
  
  def count
    songs.count
  end
  
  def contains(song)
    songs.include? song
  end
end