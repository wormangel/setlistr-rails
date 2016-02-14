class Setlist < ActiveRecord::Base
  audited
  belongs_to :band
  belongs_to :concert
  has_many :setlist_songs, -> { order('pos ASC') }
  has_many :songs, :class_name => "Song", :through => :setlist_songs
  
  def empty?
    songs.count == 0
  end
  
  def count
    songs.count
  end
  
  def running_time
    setlist_songs.inject(0) { |sum, s| s.song ? (s.song.duration ? sum + s.song.duration : sum) : sum }
  end
  
  def contains(song)
    songs.include? song
  end
  
  def title
    if self.master
      "Master setlist"
    elsif self.concert != nil
      "#{self.concert.date} - #{self.concert.name} at #{self.concert.venue}"
    else
      "Setlist created at #{self.setlist.created_at}"
    end
  end
  
  def add_song(song, pos)
    # For master setlist, don't allow duplicates
    if self.master
      if self.contains(song)
        false
      else
        SetlistSong.create(setlist: self, song: song, pos: pos) # pos is unused right now for master
      end
    else # For concert setlist, allow duplicates since we have the position determined
      SetlistSong.create(setlist: self, song: song, pos: pos)
    end
  end
  
  def remove_song(song)
    if self.contains(song)
      setlist_song = SetlistSong.find_by(:setlist_id => self.id, :song_id => song.id)
      setlist_song.destroy
    end
  end

  def as_json(options={})
    super(
      :except => [:created_at,:updated_at],
      :methods => [:count],
      :include => {
        :setlist_songs => { :only => [:id, :pos],
          :include => { :song => {:only => [:id, :artist, :title, :duration]} }
        }
      }
    )
  end

  def generate_playlist_with_songs(playlist_name, spotify_token, spotify_user_id)
    spotify_user_hash = {"provider"=>"spotify", "id"=>spotify_user_id, "credentials" => {"token" => spotify_token}}
    spotify_user = RSpotify::User.new(spotify_user_hash)
    playlist = spotify_user.create_playlist!(playlist_name)
    playlist_tracks = []
    songs.each do |song|
      if song.spotify_url.present?
        track_id = song.spotify_url.split("/")[-1]
        spotify_track = RSpotify::Track.find(track_id)
        playlist_tracks.push(spotify_track)
      end
    end
    playlist.add_tracks!(playlist_tracks)
    playlist_url = playlist.external_urls['spotify'] unless playlist.external_urls['spotify'] == nil or playlist.external_urls['spotify'].empty?
    self.update_attributes(:spotify_playlist_url => playlist_url)
  end
end
