class AddJobIdToInterview < ActiveRecord::Migration
  def change
    add_column :interviews, :job_id, :integer, null: false
    add_index :interviews, :job_id
  end
end
