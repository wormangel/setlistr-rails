class AddConcertToSetlist < ActiveRecord::Migration
  def change
    change_table :setlists do |t|
      t.belongs_to :concert, index: true, foreign_key: true, null: true
    end
  end
end
