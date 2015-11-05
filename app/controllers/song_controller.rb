class SongController < ApplicationController
  before_filter :require_authorization
  before_filter { require_band_member(params[:band_id]) }
  
  def index
    @band = Band.find(params[:band_id])
    @songs = @band.songs
    
    render 'index', layout: 'band'
  end
  
  def show
    @band = Band.find(params[:band_id])
    @song = @band.songs.find(params[:id])
    
    render 'show', layout: 'band'
  end
  
  def edit
    @band = Band.find(params[:band_id])
    @song = @band.songs.find(params[:id])
    
    render 'edit', layout: 'band'
  end
  
  def update
  end
  
  def find_media
    @band = Band.find(params[:band_id])
    @song = @band.songs.find(params[:id])

    only = params[:only]
    
    # Calls the model to find the missing media.
    # If the user clicked to trigger a specific field, try to find and save only that
    result = only != nil ? @song.find_media(only: only) : @song.find_media
    
    # The result is a hash with two keys, :success and :fail, each with an array of the
    # fields that were successfully saved or not, respectively
    if result[:success].size > 0
      flash[:notice] = 'Song information updated: ' + result[:success].to_s
    end
    
    if result[:fail].size > 0
      flash[:alert] = 'Song information not updated: ' + result[:fail].to_s
    end
    
    redirect_to :action => 'show'
  end
  
  def batch_find_media
    @band = Band.find(params[:band_id])
    @songs = @band.songs
    
    # Same as find_media but for all songs that has missing data
    all_results = []
    @songs.each do |song|
      if song.missing_crawlable_media
        result = song.find_media
        all_results << result
      end
    end
    
    # TODO do something with the results. Decide a nice way of showing it
    
    redirect_to :action => 'index'
  end
  
end