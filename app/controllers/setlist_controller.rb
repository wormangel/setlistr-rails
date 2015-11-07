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
    
    @song = Song.where(song_params).first_or_create

    if @setlist.add_song(@song)
      flash[:notice] = "Song added successfully!"
    else
      flash[:alert] = "The song was not added to the setlist! Maybe it was already there?"
    end
    
    redirect_to :action => 'show'
  end
  
  def add_batch
    @band = Band.find(params[:band_id])
    @setlist = @band.setlist
    @batch = params[:batch]
    
    total = @batch.lines.size
    success = 0
    @batch.each_line do |line|
      splitted_line = line.split(' - ')
      artist = splitted_line[0].strip
      title = splitted_line[1].strip
      spotify_url = nil
      if splitted_line.length > 2
        spotify_url = splitted_line[2]
      end
      
      song = Song.where({"artist"=>artist, "title"=>title, "band_id"=>@band.id}).first_or_create
      song.spotify_url = spotify_url
      song.save
      if @setlist.add_song(song)
        success += 1
      end
    end
    
    if success > 0
      flash[:notice] = success.to_s + " songs out of " + total.to_s + " were added successfully!"
    else
      flash[:alert] = "None of the songs were added to the setlist. Maybe they were all added before?"
    end
  
    redirect_to :action => 'show'
  end
  
  def remove_song
    @band = Band.find(params[:band_id])
    @song = Song.find(params[:song_id])
    @setlist = @band.setlist
    
    if @setlist.contains(@song)
      @setlist.remove_song(@song)
      flash[:notice] = "Song removed successfully!"
    end
    
    redirect_to :action => 'show'
  end
  
  def export
    band = Band.find(params[:band_id])
    setlist = band.setlist
    
    result = ''
    setlist.songs.order(:artist, :title).each do |song|
      result += song.artist + ' - ' + song.title + "\n"
    end
    
    send_data result, :filename => (band.name + ' - Setlist (' + Time.now.strftime('%Y%m%d') + ').txt')
  end
  
  def setlist_builder
    @band = Band.find(params[:band_id])
    @setlist = Setlist.where(band: @band, concert_id: params[:concert_id]).first_or_create
    
    render 'setlist_builder', layout: 'band'
  end
  
  private
  def song_params
    # Add the band id
    params[:song][:band_id] = params[:band_id]
    # Trim the artist and title
    params[:song][:artist] = params[:song][:artist].strip
    params[:song][:title] = params[:song][:title].strip
    params[:song][:spotify_url] = params[:song][:spotify_url].strip
    params.require(:song).permit(:artist, :title, :spotify_url, :band_id)
  end
  
end
