class CreateSetlists < ActiveRecord::Migration
  def change
    create_table :setlists do |t|
      t.belongs_to :band, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
