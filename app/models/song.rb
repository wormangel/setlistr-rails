require "vagalume"

class Song < ActiveRecord::Base
  audited
  before_save :correct_linefeed
  belongs_to :band
  
  # Declare the same relationship here so we can use :dependent => destroy
  has_many :setlist_songs
  has_many :setlists, :class_name => "Setlist", :through => :setlist_songs, :dependent => :destroy

  validates :artist, presence: true
  validates :title, presence: true

  DURATION_KEY = 'duration'
  SPOTIFY_KEY = 'spotify_url'
  PREVIEW_KEY = 'preview_url'
  LYRICS_KEY = 'lyrics'
  YOUTUBE_KEY = 'youtube_id'

  SPOTIFY_VARS = [DURATION_KEY, SPOTIFY_KEY, PREVIEW_KEY]
  VAGALUME_VARS = [LYRICS_KEY, YOUTUBE_KEY]
  YOUTUBE_VARS = [YOUTUBE_KEY]
  UPDATABLE_ATTRIBUTES = SPOTIFY_VARS + VAGALUME_VARS

  def ==(o)
    o.class == self.class && 
      o.artist == self.artist && 
      o.title == self.title
  end
  
  def fix_lyrics_linefeeds
    self.lyrics = self.lyrics.encode(:universal_newline => true)
    self.save
  end
  
  def missing_crawlable_media
    self.spotify_url = nil if self.spotify_url != nil and self.spotify_url.empty?
    self.youtube_id = nil if self.youtube_id != nil and self.youtube_id.empty?
    self.preview_url = nil if self.preview_url != nil and self.preview_url.empty?
    self.lyrics = nil if self.lyrics != nil and self.lyrics.empty?
    self.duration == nil or self.spotify_url == nil or self.lyrics == nil or self.preview_url == nil or self.youtube_id == nil
  end
  
  def find_media(only: "")
    result = {:success => [], :fail => []}

    # test for invalid input
    is_only_param_invalid = only.empty? ? false : !UPDATABLE_ATTRIBUTES.include?(only)

    return result unless missing_crawlable_media or is_only_param_invalid

    to_update = get_updatable_variables(only)

    newValues = {}

    # Spotify info
    begin
      newValues = newValues.merge(get_info_from_spotify) if (to_update & SPOTIFY_VARS).count > 0
    rescue Exception => e
      puts "Error fetching media info from Spotify! Exception:" + e
    end

    # Vagalume info - might find youtube info as well
    begin
      newValues = newValues.merge(get_info_from_vagalume(to_update.include? YOUTUBE_KEY)) if (to_update & VAGALUME_VARS).count > 0
    rescue Exception => e
      puts "Error fetching media info from Vagalume! Exception:" + e
    end

    # Youtube only info
    begin
      newValues = newValues.merge(get_info_from_youtube) if (to_update & YOUTUBE_VARS).count > 0
    rescue Exception => e
      puts "Error fetching media info from Youtube! Exception:" + e
    end
    
    to_update.each do |var|
      if self.attributes[var] == nil and newValues[var] != nil
        self.update_attributes(var => newValues[var]) 
      end
    end

    self.save

    result[:success] = to_update.compact.select { |var| self.attributes[var] != newValues[var] and self.attributes[var] != nil }
    result[:fail] = to_update.compact.select { |var| self.attributes[var] == nil}

    result
  end

  def get_updatable_variables(only)
    updatable_vars = []
    if only.empty?
      updatable_vars += [DURATION_KEY] if self.attributes[DURATION_KEY] == nil
      updatable_vars += [SPOTIFY_KEY] if self.attributes[SPOTIFY_KEY] == nil
      updatable_vars += [PREVIEW_KEY] if self.attributes[PREVIEW_KEY] == nil
      updatable_vars += [LYRICS_KEY] if self.attributes[LYRICS_KEY] == nil
      updatable_vars += [YOUTUBE_KEY] if self.attributes[YOUTUBE_KEY] == nil
    else
      updatable_vars += [only] if self.attributes[only] == nil
    end
    updatable_vars
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

  def get_info_from_vagalume(needs_youtube)
    response = {}
    result = Vagalume.find(art: self.artist, mus: self.title, ytid: true)
    if !result.not_found?
      song = result.song
      response[LYRICS_KEY] = song.lyric if song != nil and song.lyric != nil and !song.lyric.empty?
      response[YOUTUBE_KEY] = song.youtube_id if song != nil and song.youtube_id != nil and !song.youtube_id.empty?
    end

    # YoutubeID is deprecated in VagalumeAPI, in some cases there is no video id for the lyrics
    # In this case we will use yourub to get the video.
    if needs_youtube and response[YOUTUBE_KEY] == nil
      response = response.merge(get_info_from_youtube)
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
  
  private
  def correct_linefeed
    if self.lyrics != nil
      self.lyrics = self.lyrics.encode(:universal_newline => true)
    end
  end

end
