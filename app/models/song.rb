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
    self.media_url = nil if self.media_url != nil and self.media_url.empty?
    self.duration == nil or self.media_url == nil
  end
  
  def find_media(only: "")
    # TODO this should check for missing crawlable info and call the appropriate crawler for each field, saving the song in the end
    # and returning a hash with keys :success and :fail, each with an array of the fields that were found and saved and the ones that weren't found, respectively
    
    # It may receive an only parameter, specifying which field should be crawled and saved.
    result = {:success => [], :fail => []}

    return result unless missing_crawlable_media

    query = "track:#{self.title} artist:#{self.artist}"
    track = RSpotify::Track.search(query, limit: 1).first
    if track != nil

      duration = track.duration_ms / 1000 unless track.duration_ms != nil
      url = track.external_urls['spotify'] unless track.external_urls['spotify'] == nil or track.external_urls['spotify'].empty? 
      #30 second preview
      #preview = track.preview_url

      response = { "duration" => duration, "media_url" => url = url }
      
      updatableAttributes = ['duration', 'media_url']
      updatableVariables = only.empty? ? updatableAttributes : [only]

      updatableVariables.each do |var|
        if updatableAttributes.include? var 
          if self.attributes[var] == nil and response[var] != nil
            self.update_attributes(var => response[var]) 
          end
        end
      end
      
      self.save
    end
    
    result[:success] = updatableVariables.compact.select { |var| self.attributes[var] != nil }
    result[:fail] = updatableVariables.compact.select { |var| self.attributes[var] == nil }

    result
  end

end
