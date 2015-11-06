class Song < ActiveRecord::Base
  audited
  belongs_to :band

  validates :artist, presence: true
  validates :title, presence: true

  CONST_DURATION = 'duration'
  CONST_SPOTIFY = 'spotify_url'
  CONST_PREVIEW = 'preview_url'
  CONST_LYRICS = 'lyrics'
  CONST_YOUTUBE = 'youtube_url'

  def ==(o)
    o.class == self.class && 
      o.artist == self.artist && 
      o.title == self.title
  end
  
  def missing_crawlable_media
    # TODO returns true if it's missing any of the crawlable info: duration and spotify_url (later will add lyrics to that)
    self.spotify_url = nil if self.spotify_url != nil and self.spotify_url.empty?
    self.youtube_url = nil if self.youtube_url != nil and self.youtube_url.empty?
    self.preview_url = nil if self.preview_url != nil and self.preview_url.empty?
    self.lyrics = nil if self.lyrics != nil and self.lyrics.empty?
    self.duration == nil or self.spotify_url == nil or self.lyrics == nil or self.preview_url == nil or self.youtube_url == nil
  end
  
  def find_media(only: "")
    # TODO this should check for missing crawlable info and call the appropriate crawler for each field, saving the song in the end
    # and returning a hash with keys :success and :fail, each with an array of the fields that were found and saved and the ones that weren't found, respectively
    
    # It may receive an only parameter, specifying which field should be crawled and saved.
    result = {:success => [], :fail => []}

    return result unless missing_crawlable_media

    infoFromSpotify = [CONST_DURATION, CONST_SPOTIFY, CONST_PREVIEW]
    infoLyric = [CONST_LYRICS]
    infoYoutube = [CONST_YOUTUBE]
    updatableAttributes = infoFromSpotify + infoLyric = infoYoutube
    updatableVariables = only.empty? ? updatableAttributes : [only]

    newValues = {}
    newValues = newValues.merge(get_info_from_spotify) if only.empty? or infoFromSpotify.include? only
    newValues = newValues.merge(get_lyric) if only.empty? or infoLyric.include? only
    newValues = newValues.merge(get_info_from_youtube) if only.empty? or infoYoutube.include? only
    
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

  def get_info_from_spotify
    response = {}

    query = "track:#{self.title} artist:#{self.artist}"
    track = RSpotify::Track.search(query, limit: 1).first
    if track != nil
      response[CONST_DURATION] = track.duration_ms / 1000 unless track.duration_ms == nil
      response[CONST_SPOTIFY] = track.external_urls['spotify'] unless track.external_urls['spotify'] == nil or track.external_urls['spotify'].empty? 
      response[CONST_PREVIEW] = track.preview_url unless track.preview_url == nil or track.preview_url.empty?
    end
    response
  end

  def get_lyric
    response = {}
    fetcher = Lyricfy::Fetcher.new
    song = fetcher.search self.artist, self.title
    response[CONST_LYRICS] = song.body("<br>") if song != nil and song.body != nil and !song.body.empty?
    response
  end

  def get_info_from_youtube
    response = {}
    query = "#{self.artist} #{self.title}"
    appKey = Rails.application.config.youtube_dev_key
    appName = Rails.application.config.youtube_app_name
    client = Yourub::Client.new({ developer_key: appKey, application_name: appName })
    client.search(query: query, max_results: 1) do |video|
      response[CONST_YOUTUBE] = "http://www.youtube.com/watch?v=" + video['id'] if video != nil and video['id'] != nil and !video['id'].empty?
    end
    response
  end
end
