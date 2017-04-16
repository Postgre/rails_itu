class RenameUserAccessTokenToItuId < ActiveRecord::Migration
  def change
    rename_column :users, :access_token, :itu_id
  end
end
