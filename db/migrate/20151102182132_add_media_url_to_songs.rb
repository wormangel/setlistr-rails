class AddMediaUrlToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :media_url, :string
  end
end
