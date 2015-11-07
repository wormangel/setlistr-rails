class AddMasterFlagToSetlist < ActiveRecord::Migration
  def change
    add_column :setlists, :master, :boolean, :default => true
  end
end
