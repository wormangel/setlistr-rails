class AddBandToSong < ActiveRecord::Migration
  def change
    change_table :songs do |t|
      t.belongs_to :band, index: true, foreign_key: true
    end
  end
end
