class AddSpotifyUriToUsers < ActiveRecord::Migration
  def change
    add_column :users, :spotify_uri, :string
  end
end
