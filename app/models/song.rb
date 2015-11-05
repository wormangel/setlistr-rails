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
    self.preview_url = nil if self.preview_url != nil and self.preview_url.empty?
    self.lyrics = nil if self.lyrics != nil and self.lyrics.empty?
    self.duration == nil or self.media_url == nil or self.lyrics == nil or self.preview_url == nil
  end
  
  def find_media(only: "")
    # TODO this should check for missing crawlable info and call the appropriate crawler for each field, saving the song in the end
    # and returning a hash with keys :success and :fail, each with an array of the fields that were found and saved and the ones that weren't found, respectively
    
    # It may receive an only parameter, specifying which field should be crawled and saved.
    result = {:success => [], :fail => []}

    return result unless missing_crawlable_media

    infoFromSpotify = ['duration', 'media_url', 'preview_url']
    infoLyric = ['lyric']
    updatableAttributes = infoFromSpotify + infoLyric
    updatableVariables = only.empty? ? updatableAttributes : [only]

    newValues = {}
    newValues = newValues.merge(get_info_from_spotify) if only.empty? or infoFromSpotify.include? only
    newValues = newValues.merge(get_lyric) if only.empty? or infoLyric.include? only
    
    updatableVariables.each do |var|
      if updatableAttributes.include? var 
        if self.attributes[var] == nil and newValues[var] != nil
          self.update_attributes(var => newValues[var]) 
        end
      end
    end

    self.save

    result[:success] = updatableVariables.compact.select { |var| self.attributes[var] != newValues[var] and self.attributes[var] != nil }
    result[:fail] = updatableVariables.compact.select { |var| self.attributes[var] == nil}

    result
  end

  def get_info_from_spotify()
    response = {}

    query = "track:#{self.title} artist:#{self.artist}"
    track = RSpotify::Track.search(query, limit: 1).first
    if track != nil
      response["duration"] = track.duration_ms / 1000 unless track.duration_ms == nil
      response["media_url"] = track.external_urls['spotify'] unless track.external_urls['spotify'] == nil or track.external_urls['spotify'].empty? 
      response["preview_url"] = track.preview_url unless track.preview_url == nil or track.preview_url.empty?
    end
    response
  end

  def get_lyric()
    response = {}

    #To supress some bugs on the Lyricfy gem (the bug is fixed on github but the gem does not have the latest code)
    begin
      fetcher = Lyricfy::Fetcher.new
      song = fetcher.search self.artist, self.title
      response['lyric'] = song.body("<br>") if song != nil and song.body != nil and !song.body.empty?
    rescue
      nil
    end
    response
  end
end
