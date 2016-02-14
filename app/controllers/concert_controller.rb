class ConcertController < ApplicationController
  before_filter :require_authorization
  before_filter { require_band_member(params[:band_id]) }
  
  def index
    @band = Band.find(params[:band_id])

    render 'index', layout: 'band'
  end
  
  def new
    @band = Band.find(params[:band_id])
    @concert = Concert.new
    
    render 'new', layout: 'band'
  end
  
  def create
    @band = Band.find(params[:band_id])

    @concert = Concert.new(concert_params)
    if @concert.save
      flash[:notice] = "Concert created successfully!"
      redirect_to band_concert_path(@band.id, @concert.id)
    else
      render 'new', layout: 'band'
    end
  end
  
  def show
    @band = Band.find(params[:band_id])
    @concert = Concert.find(params[:id])
    
    render 'show', layout: 'band'
  end
  
  def edit
    @band = Band.find(params[:band_id])
    @concert = Concert.find(params[:id])
    
    render 'edit', layout: 'band'
  end
  
  def update
    @band = Band.find(params[:band_id])
    @concert = Concert.find(params[:id])
    
    if @concert.update(concert_params)
      flash[:notice] = "Concert updated successfully!"
      redirect_to band_concert_path(@band.id, @concert.id)
    else
      render 'edit', layout: 'band'
    end
  end
  
  def export_lyrics
    band = Band.find(params[:band_id])
    concert = Concert.find(params[:id])
    
    # For windows encoding
    use_crlf = get_operating_system == :windows
    
    newline = use_crlf ? "\r\n" : "\n"
    
    result = ""
    concert.setlist.setlist_songs.each do |s|
      if s.song != nil and s.song.lyrics != nil
        result += "\"" + s.song.title.strip + "\""
        result += newline * 2
        
        result += s.song.lyrics.encode(:crlf_newline => use_crlf)
      
        result += newline * 5 # TODO Config?
      end
    end
    
    send_data result, :filename => (band.name + ' - ' + concert.name + ' - Lyrics (' + Time.now.strftime('%Y%m%d') + ').txt')
  end

  def generate_playlist
    if !current_user.is_spotify_user
      flash[:alert] = "You have to connect your account to a Spotify account!"
      redirect_to edit_user_path
    else
      concert = Concert.find(params[:id])
      playlist_name = concert.name
      # Use a thread for that
      spotify_auth_token = current_user.spotify_oauth_token
      spotify_user_id = current_user.spotify_uri.split(":")[-1]
      CreatePlaylistWorker.perform_async(concert.setlist.id, playlist_name, spotify_auth_token, spotify_user_id)

      flash[:notice] = 'We are creating your playlist in the background. It should finish after a while, check back soon!'

      redirect_to :action => 'show'
    end
  end

  def concert_params
    params[:concert][:band_id] = params[:band_id]
    params.require(:concert).permit(:name, :date, :time, :venue, :duration, :payment_type,
     :payment, :flyer, :description, :ticket_price, :band_id)
  end
end