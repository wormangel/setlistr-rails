class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :author
      t.string :title
      t.integer :duration

      t.timestamps null: false
    end
  end
end
