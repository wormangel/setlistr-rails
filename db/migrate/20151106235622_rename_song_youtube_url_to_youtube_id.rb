class RenameSongYoutubeUrlToYoutubeId < ActiveRecord::Migration
  def change
    rename_column :songs, :youtube_url, :youtube_id
  end
end
