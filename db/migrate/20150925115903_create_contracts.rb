class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.belongs_to :user, index:true
      t.belongs_to :band, index:true
      t.string :instrument
      t.datetime :date_joined
      t.datetime :date_left
      t.timestamps null: false
    end
  end
end
