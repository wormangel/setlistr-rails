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

    puts song_params
    @song = Song.get_or_create(song_params)

    if @setlist.add_song(@song)
      flash[:notice] = "Song added successfully!"
    else
      flash[:alert] = "The song was not added to the setlist!"
    end
    
    redirect_to :action => 'show', layout: 'band'
  end
  
  def add_batch
    @band = Band.find(params[:band_id])
    @setlist = @band.setlist
    @batch = params[:batch]
    
    total = @batch.lines.size
    success = 0
    @batch.each_line do |line|
      artist = line.split(' - ')[0]
      title = line.split(' - ')[1]
      
      song = Song.get_or_create({"artist"=>artist, "title"=>title})
      if @setlist.add_song(song)
        success = success + 1
      end
    end
    
    if success > 0
      flash[:notice] = success.to_s + " songs out of " + total.to_s + " were added successfully!"
    else
      flash[:alert] = "None of the songs were added to the setlist"
    end
  
    redirect_to :action => 'show', layout: 'band'
  end
  
  def remove_song
    @band = Band.find(params[:band_id])
    @song = Song.find(params[:song_id])
    @setlist = @band.setlist
    
    if @setlist.contains(@song)
      @setlist_song = SetlistSong.find_by(:setlist_id => @setlist.id, :song_id => @song.id)
      @setlist_song.destroy
      flash[:notice] = "Song removed successfully!"
    end
    
    redirect_to :action => 'show', layout: 'band'
  end
  
  def export
    band = Band.find(params[:band_id])
    setlist = band.setlist
    
    result = ''
    setlist.songs.each do |song|
      result += song.artist + ' - ' + song.title
    end
    
    send_data result, :filename => (band.name + ' - Setlist (' + Time.now.strftime('%Y%m%d') + ').txt')
  end
  
  private
  def song_params
    params.require(:song).permit(:artist, :title)
  end
  
end
