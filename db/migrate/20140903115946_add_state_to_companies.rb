class AddStateToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :state, :string, null: false
    add_index :companies, :state
  end
end
