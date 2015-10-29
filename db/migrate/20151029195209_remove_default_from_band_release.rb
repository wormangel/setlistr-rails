class RemoveDefaultFromBandRelease < ActiveRecord::Migration
  def change
    change_column_default :bands, :release, nil
  end
end
