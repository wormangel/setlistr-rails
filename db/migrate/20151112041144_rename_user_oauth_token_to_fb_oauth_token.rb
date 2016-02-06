class RenameUserOauthTokenToFbOauthToken < ActiveRecord::Migration
  def change
  	rename_column :users, :oauth_token, :fb_oauth_token
  end
end
