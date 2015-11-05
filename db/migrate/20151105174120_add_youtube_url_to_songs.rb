class AddYoutubeUrlToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :youtube_url, :string
  end
end
