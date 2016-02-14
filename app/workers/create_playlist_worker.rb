class CreatePlaylistWorker
  include Sidekiq::Worker

  def perform(setlist_id, playlist_name, spotify_token, spotify_user_id)
  	setlist = Setlist.find(setlist_id)
  	setlist.generate_playlist_with_songs(playlist_name, spotify_token, spotify_user_id)
  end
end