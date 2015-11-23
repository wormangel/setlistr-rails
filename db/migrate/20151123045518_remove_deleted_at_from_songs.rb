class RemoveDeletedAtFromSongs < ActiveRecord::Migration
  def change
    SetlistSong.includes(:song).where.not('songs.deleted_at' => nil).destroy_all
    Song.where.not('deleted_at' => nil).destroy_all
    
    remove_column :songs, :deleted_at
  end
end
