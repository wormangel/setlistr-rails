class AddLyricToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :lyric, :string
  end
end
