class AddSpotifyOauthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :spotify_oauth_token, :string
  end
end
