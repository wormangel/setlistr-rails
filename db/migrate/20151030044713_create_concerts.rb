class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.belongs_to :band, index:true
      t.string :name
      t.date :date
      t.time :time
      t.string :venue
      t.integer :duration
      t.string :description
      t.decimal :ticket_price
      t.string :payment_type
      t.decimal :payment
      t.string :flyer

      t.timestamps null: false
    end
  end
end
