class RenameSongLyricToLyrics < ActiveRecord::Migration
  def change
    rename_column :songs, :lyric, :lyrics
  end
end
