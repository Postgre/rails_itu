class AddEmsIds < ActiveRecord::Migration
  def change
    remove_column :users, :ems_id, :string
    add_column :users, :ems_user_id, :string
    add_column :candidates, :ems_student_id, :string

    add_index :users, :ems_user_id
    add_index :candidates, :ems_student_id
  end
end
