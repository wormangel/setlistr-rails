class AddBandCompleteToBand < ActiveRecord::Migration
  def change
    add_column :bands, :band_complete, :boolean, :default => false
  end
end
