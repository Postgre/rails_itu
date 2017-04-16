class RemoveRequirementsFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :requirements
  end
end
