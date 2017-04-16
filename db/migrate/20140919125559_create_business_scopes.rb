class CreateBusinessScopes < ActiveRecord::Migration
  def change
    create_table :business_scopes do |t|
      t.string :name

      t.timestamps
    end

    add_column :companies, :business_scope_id, :integer
    add_index :companies, :business_scope_id
  end
end
