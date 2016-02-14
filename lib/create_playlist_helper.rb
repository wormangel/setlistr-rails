module CreatePlaylistHelper

  def generate_playlist_for_setlist(setlist_id, playlist_name)
    if !current_user.is_spotify_user
       flash[:alert] = "You have to connect your account to a Spotify account!"
       redirect_to edit_user_path(:id=>current_user.id)
    else
      # Use a thread for that
      spotify_auth_token = current_user.spotify_oauth_token
      spotify_user_id = current_user.spotify_uri.split(":")[-1]
      CreatePlaylistWorker.perform_async(setlist_id, playlist_name, spotify_auth_token, spotify_user_id)

      flash[:notice] = 'We are creating your playlist in the background. It should finish after a while, check back soon!'

      redirect_to :action => 'show'
    end
  end

end