class FindMediaInfoBatchWorker
  include Sidekiq::Worker
 
  def perform(band_id)
    band = Band.find(band_id)
    band.songs.each do |song|
      if song.missing_crawlable_media
        result = song.find_media # TODO Maybe wait on the thread and store/push the results?
      end
    end
  end
end