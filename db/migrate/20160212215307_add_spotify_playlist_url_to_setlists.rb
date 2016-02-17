class AddSpotifyPlaylistUrlToSetlists < ActiveRecord::Migration
  def change
    add_column :setlists, :spotify_playlist_url, :string
  end
end
