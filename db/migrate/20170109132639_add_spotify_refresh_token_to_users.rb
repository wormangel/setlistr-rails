class AddSpotifyRefreshTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :spotify_refresh_token, :string
  end
end
