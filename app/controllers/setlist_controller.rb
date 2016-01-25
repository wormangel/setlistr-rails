class SetlistController < ApplicationController
  before_filter :require_authorization
  before_filter { require_band_member(params[:band_id]) }
  
  def show
    @band = Band.find(params[:band_id])
    if params[:id]
      @setlist = @band.setlists.find(params[:id])
    else
      @setlist = @band.setlist
    end
    
    @new_song = Song.new
    
    respond_to do |format|
      format.html { render 'show', layout: 'band' }
      format.json { render json: @setlist.to_json }
    end
  end
  
  def add_song
    @band = Band.find(params[:band_id])
    @setlist = @band.setlist
    
    @song = Song.where(song_params).first_or_create

    if @setlist.add_song(@song, nil)
      flash[:notice] = "Song added successfully!"
    else
      flash[:alert] = "The song was not added to the setlist! Maybe it was already there?"
    end
    
    redirect_to band_master_setlist_path(@band)
  end
  
  def add_batch
    @band = Band.find(params[:band_id])
    @setlist = @band.setlist
    @batch = params[:batch]
    
    total = @batch.lines.size
    success = 0
    @batch.each_line do |line|
      splitted_line = line.split(' - ')
      next unless splitted_line.length > 1
      artist = splitted_line[0].strip
      title = splitted_line[1].strip
      spotify_url = nil
      if splitted_line.length > 2
        spotify_url = splitted_line[2]
      end
      
      song = Song.where({"artist"=>artist, "title"=>title, "band_id"=>@band.id}).first_or_create
      song.spotify_url = spotify_url
      song.save
      if @setlist.add_song(song, nil)
        success += 1
      end
    end
    
    if success > 0
      flash[:notice] = success.to_s + " songs out of " + total.to_s + " were added successfully!"
    else
      flash[:alert] = "None of the songs were added to the setlist. Maybe they were all added before?"
    end
  
    redirect_to band_master_setlist_path(@band)
  end
  
  def remove_song
    @band = Band.find(params[:band_id])
    @song = Song.find(params[:song_id])
    @setlist = @band.setlist
    
    if @setlist.contains(@song)
      @setlist.remove_song(@song)
      flash[:notice] = "Song removed successfully!"
    end
    
    redirect_to band_master_setlist_path(@band)
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
    @concert = Concert.find(params[:id])
    @setlist = Setlist.where(band: @band, concert: @concert, master: false).first_or_create
    
    @base_setlists = []
    @base_setlists << @band.setlist
    
    @band.setlists.where.not(concert: @concert, master: true).each do |setlist|
      @base_setlists << setlist
    end

    render 'setlist_builder', layout: 'band'
  end
  
  def update_concert_setlist
    @band = Band.find(params[:band_id])
    @concert = Concert.find(params[:id])
    
    @setlist = Setlist.where(band: @band, concert: @concert).first
    
    if params[:op] == 'add'
      song = Song.find(params[:song_id])
      saved_setlist_song = @setlist.add_song(song, params[:pos])
      result = saved_setlist_song.id
      @concert.update_setlist_after_save(saved_setlist_song)
    elsif params[:op] == 'update'
      setlist_song = SetlistSong.find(params[:setlist_song_id])
      old_value = setlist_song.pos
      setlist_song.pos = params[:pos]
      if setlist_song.save
        result = setlist_song.id
        @concert.update_setlist_after_update(setlist_song, old_value)
      else
        flash['alert'] = 'An error has occured.'
      end
    elsif params[:op] == 'destroy'
      setlist_song = SetlistSong.find(params[:setlist_song_id])
      old_value = setlist_song.pos
      setlist_song.destroy
      result = setlist_song.id
      @concert.update_setlist_after_destroy(old_value)
    else
      flash['alert'] = 'Unsupported action invoked. Please reload the page or report if this keeps happening.' and return
    end
    
    respond_to do |format|
      format.json { render json: result }
    end
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
