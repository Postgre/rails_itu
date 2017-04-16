class ReturnEmsIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ems_id, :string
  end
end
