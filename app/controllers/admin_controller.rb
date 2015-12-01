class AdminController < ApplicationController
  before_filter :require_authorization
  before_filter :require_admin
  
  def toolbox
    @wrong_lf_count = 0
    Song.find_each do |s|
      if s.lyrics and s.lyrics.include?("\r")
        @wrong_lf_count += 1
      end
    end
  
    @dirty_setlists = []
    Setlist.where(master: false).each do |setlist|
      proper_pos = 0
      setlist.setlist_songs.each do |song|
        if song.pos != proper_pos
          @dirty_setlists << "#{setlist.band.name} - #{setlist.concert.name}"
          break
        end
        proper_pos += 1
      end
    end
    render 'toolbox', layout: 'admin'
  end
  
  def bands
    @bands = Band.all.order(:id)
    
    render 'bands', layout: 'admin'
  end
  
  def users
    @users = User.all
  
    render 'users', layout: 'admin'
  end
  
  def database
    @band_count = Band.count
    @user_count = User.count
    @contract_count = Contract.count
    @song_count = Song.count
    @concert_count = Concert.count
    @setlist_song_count = SetlistSong.count
    @setlist_count = Setlist.count
    @audit_count = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM "audits"').getvalue(0,0).to_i
    
    @total = @band_count + @user_count + @contract_count + @song_count + @concert_count + @setlist_song_count + @setlist_count + @audit_count
    
    render 'database', layout: 'admin'
  end
  
  def lyricsfix
    FixLyricsLinefeedWorker.perform_async
    
    # TODO do something with the results. Decide a nice way of showing it
    flash[:notice] = "Work begun in the background. In a moment all lyrics should be using the universal linefeed character (\\n)."
  
    redirect_to :admin_toolbox
  end
  
  def setlist_order_fix
    FixSetlistOrderWorker.perform_async

    # TODO do something with the results. Decide a nice way of showing it
    flash[:notice] = "Work begun in the background. In a moment all setlists should be properly ordered."
  
    redirect_to :admin_toolbox
  end
end