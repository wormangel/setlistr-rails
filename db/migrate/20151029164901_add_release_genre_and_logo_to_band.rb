class AddReleaseGenreAndLogoToBand < ActiveRecord::Migration
  def change
    add_column :bands, :release, :text, :default => true
    add_column :bands, :genre, :string
    add_column :bands, :logo, :string
  end
end
