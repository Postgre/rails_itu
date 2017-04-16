class AddIndexesToJobApplications < ActiveRecord::Migration
  def change
    add_index :job_applications, :candidate_id
    add_index :job_applications, :job_id
  end
end
