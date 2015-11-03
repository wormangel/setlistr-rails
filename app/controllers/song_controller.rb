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
  
end