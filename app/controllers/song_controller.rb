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
    @band = Band.find(params[:band_id])
    @song = @band.songs.find(params[:id])
    
    if @song.update(song_params)
      flash[:notice] = "Song updated successfully!"
      redirect_to band_song_path(@band, @song)
    else
      render 'edit', layout: 'band'
    end
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
    # Same as find_media but for all songs that has missing data
    # Use a thread for that
    FindMediaInfoBatchWorker.perform_async params[:band_id]
    
    # TODO do something with the results. Decide a nice way of showing it
    flash[:notice] = 'We are looking for the missing info in the background. It should finish after a while, check back later!'
    
    redirect_to :action => 'index'
  end
  
  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = 'Song deleted successfully.'
    
    redirect_to :action => 'index'
  end
  
  def song_params
    params[:song][:band_id] = params[:band_id]
    params.require(:song).permit(:artist, :title, :duration, :spotify_url, :preview_url, :youtube_id, :lyrics, :band_id)
  end
  
end