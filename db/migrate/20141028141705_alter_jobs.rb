class AlterJobs < ActiveRecord::Migration
  def change
    change_column :jobs, :work_type, :integer
    change_column :jobs, :schedule, :integer
    change_column :jobs, :estimated_length, :integer
  end
end
