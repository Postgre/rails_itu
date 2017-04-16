class RenameBusinessScopeIdColumn < ActiveRecord::Migration
  def change
    rename_column :companies, :business_scope_id, :industry_id
  end
end
