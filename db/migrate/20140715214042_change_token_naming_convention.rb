class ChangeTokenNamingConvention < ActiveRecord::Migration
  def change
    rename_column :users, :authentication_token, :access_token
  end
end
