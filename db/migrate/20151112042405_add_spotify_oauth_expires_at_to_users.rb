class AddSpotifyOauthExpiresAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :spotify_oauth_expires_at, :string
  end
end
