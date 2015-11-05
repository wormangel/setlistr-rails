class AddPreviewUrlToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :preview_url, :string
  end
end
