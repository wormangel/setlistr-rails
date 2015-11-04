class Song < ActiveRecord::Base
  audited
  belongs_to :band

  validates :artist, presence: true
  validates :title, presence: true

  def ==(o)
    o.class == self.class && 
      o.artist == self.artist && 
      o.title == self.title
  end
  
  def missing_crawlable_media
    # TODO returns true if it's missing any of the crawlable info: duration and media_url (later will add lyrics to that)
    
    # test result
    true
  end
  
  def find_media(only: nil)
    # TODO this should check for missing crawlable info and call the appropriate crawler for each field, saving the song in the end
    # and returning a hash with keys :success and :fail, each with an array of the fields that were found and saved and the ones that weren't found, respectively
    
    # It may receive an only parameter, specifying which field should be crawled and saved.
    
    # test result
    result = {}
    if only != nil
      result[:success] = [only]
      result[:fail] = []
    else
      result[:success] = ['media_url','duration']
      result[:fail] = ['lyrics']
    end
    
    result
  end
end
