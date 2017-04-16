class RemoveStatusFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :status
  end
end
