class CreatePlaylistWorker
  include Sidekiq::Worker
 
  def perform(setlist_id, user_auth, playlist_name)
  	setlist = Setlist.find(setlist_id)
  	setlist.generate_playlist_with_songs(playlist_name, user_auth)
  end
end