class AlterEmsIds < ActiveRecord::Migration
  def change
    remove_column :users, :ems_user_id
    remove_column :candidates, :ems_student_id

    add_column :users, :ems_user_id, :integer
    add_column :candidates, :ems_student_id, :integer

    add_index :users, :ems_user_id
    add_index :candidates, :ems_student_id
  end
end
