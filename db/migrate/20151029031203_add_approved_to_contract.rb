class AddApprovedToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :approved, :boolean, :default => true
  end
end
