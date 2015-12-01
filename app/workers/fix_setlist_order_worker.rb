class FixSetlistOrderWorker
  include Sidekiq::Worker
 
  def perform
    dirty_setlists = []
    Setlist.where(master: false).each do |setlist|
      proper_pos = 0
      setlist.setlist_songs.each do |song|
        if song.pos != proper_pos
          dirty_setlists << setlist
          break
        end
        proper_pos += 1
      end
    end
    
    logger.debug dirty_setlists.count
    
    dirty_setlists.each do |setlist|
      pos = 0
      setlist.setlist_songs.each do |song|
        song.pos = pos
        song.save
        pos += 1
      end
    end
  end
end