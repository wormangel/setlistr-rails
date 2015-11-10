require "vagalume"

class Song < ActiveRecord::Base
  audited
  acts_as_paranoid
  belongs_to :band

  validates :artist, presence: true
  validates :title, presence: true

  DURATION_KEY = 'duration'
  SPOTIFY_KEY = 'spotify_url'
  PREVIEW_KEY = 'preview_url'
  LYRICS_KEY = 'lyrics'
  YOUTUBE_KEY = 'youtube_id'

  def ==(o)
    o.class == self.class && 
      o.artist == self.artist && 
      o.title == self.title
  end
  
  def missing_crawlable_media
    # TODO returns true if it's missing any of the crawlable info: duration and spotify_url (later will add lyrics to that)
    self.spotify_url = nil if self.spotify_url != nil and self.spotify_url.empty?
    self.youtube_id = nil if self.youtube_id != nil and self.youtube_id.empty?
    self.preview_url = nil if self.preview_url != nil and self.preview_url.empty?
    self.lyrics = nil if self.lyrics != nil and self.lyrics.empty?
    self.duration == nil or self.spotify_url == nil or self.lyrics == nil or self.preview_url == nil or self.youtube_id == nil
  end
  
  def find_media(only: "")
    # TODO this should check for missing crawlable info and call the appropriate crawler for each field, saving the song in the end
    # and returning a hash with keys :success and :fail, each with an array of the fields that were found and saved and the ones that weren't found, respectively
    
    # It may receive an only parameter, specifying which field should be crawled and saved.
    result = {:success => [], :fail => []}

    return result unless missing_crawlable_media

    infoFromSpotify = [DURATION_KEY, SPOTIFY_KEY, PREVIEW_KEY]
    infoVagalume = [LYRICS_KEY, YOUTUBE_KEY]
    updatableAttributes = infoFromSpotify + infoVagalume
    updatableVariables = only.empty? ? updatableAttributes : [only]

    newValues = {}
    newValues = newValues.merge(get_info_from_spotify) if only.empty? or infoFromSpotify.include? only
    newValues = newValues.merge(get_info_from_vagalume) if only.empty? or infoVagalume.include? only

    # If the vagalume API does not have the lyrics it will not send the youtube video ID either.
    # In this case we will use yourub to get the video.
    if ( only.empty? or infoVagalume.include? only ) and newValues[YOUTUBE_KEY] == nil
      newValues = newValues.merge(get_info_from_youtube)
    end
    
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
      response[DURATION_KEY] = track.duration_ms / 1000 unless track.duration_ms == nil
      response[SPOTIFY_KEY] = track.external_urls['spotify'] unless track.external_urls['spotify'] == nil or track.external_urls['spotify'].empty? 
      response[PREVIEW_KEY] = track.preview_url unless track.preview_url == nil or track.preview_url.empty?
    end
    response
  end

  def get_info_from_vagalume
    response = {}
    result = Vagalume.find(art: self.artist, mus: self.title, ytid: true)
    if !result.not_found?
      song = result.song
      puts song
      response[LYRICS_KEY] = song.lyric if song != nil and song.lyric != nil and !song.lyric.empty?
      response[YOUTUBE_KEY] = song.youtube_id if song != nil and song.youtube_id != nil and !song.youtube_id.empty?
    end
    response
  end

  def get_info_from_youtube
    response = {}
    query = "#{self.artist} #{self.title}"
    appKey = Rails.application.config.youtube_dev_key
    appName = Rails.application.config.youtube_app_name
    client = Yourub::Client.new({ developer_key: appKey, application_name: appName })
    client.search(query: query, max_results: 1) do |video|
      response[YOUTUBE_KEY] = video['id'] if video != nil and video['id'] != nil and !video['id'].empty?
    end
    response
  end

end
