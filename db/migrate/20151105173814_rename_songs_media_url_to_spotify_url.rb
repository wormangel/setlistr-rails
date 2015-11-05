class RenameSongsMediaUrlToSpotifyUrl < ActiveRecord::Migration
  def change
    rename_column :songs, :media_url, :spotify_url
  end
end
