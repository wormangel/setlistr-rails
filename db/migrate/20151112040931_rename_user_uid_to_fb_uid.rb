class RenameUserUidToFbUid < ActiveRecord::Migration
  def change
  	rename_column :users, :uid, :fb_uid
  end
end
