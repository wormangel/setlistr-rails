class AddMasterFlagToSetlist < ActiveRecord::Migration
  def change
    # This will also set the existing setlists to be the master for that band
    add_column :setlists, :master, :boolean, :default => true
  end
end
