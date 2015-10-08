class SetlistController < ApplicationController
  before_filter :require_authorization
  before_filter { require_band_member(params[:band_id]) }
  
  def show
    @band = Band.find(params[:band_id])
    @setlist = @band.setlist
    
    @new_song = Song.new
    render 'show', layout: 'band'
  end
  
  def add_song
    @band = Band.find(params[:band_id])
    @setlist = @band.setlist

    if Song.exists?(song_params)
      @song = Song.where(song_params).first
    else
      @song = Song.new(song_params)
      
      if not @song.save
        @new_song = @song
        render 'show', layout: 'band' and return
      end
    end

    unless @setlist.contains(@song)
      @setlist_song = SetlistSong.new(setlist: @setlist, song: @song)
      @setlist_song.save
      flash[:notice] = "Song added successfully!"
    end
    
    redirect_to :action => 'show', layout: 'band'
  end
  
  private
  def song_params
    params.require(:song).permit(:author, :title)
  end
end
