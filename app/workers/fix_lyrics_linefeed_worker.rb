class FixLyricsLinefeedWorker
  include Sidekiq::Worker
 
  def perform
    songs = Song.where.not(lyrics: nil)
    songs.each do |song|
      song.fix_lyrics_linefeeds
    end
  end
end