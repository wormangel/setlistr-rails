class RenameUserOauthExpiresAtToFbOauthExpiresAt < ActiveRecord::Migration
  def change
  	rename_column :users, :oauth_expires_at, :fb_oauth_expires_at
  end
end
