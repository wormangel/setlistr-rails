class CreateSetlistSongs < ActiveRecord::Migration
  def change
    create_table :setlist_songs do |t|
      t.belongs_to :song, index: true, foreign_key: true
      t.belongs_to :setlist, index: true, foreign_key: true
      t.integer :pos
      t.date :date_added

      t.timestamps null: false
    end
  end
end
