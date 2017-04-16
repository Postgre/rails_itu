class EnforceUniqJobApply < ActiveRecord::Migration
  def change
    add_index :job_applications, [:job_id, :candidate_id], unique: true
  end
end
