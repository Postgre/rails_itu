class RemoveEstimatedLengthFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :estimated_length
  end
end
