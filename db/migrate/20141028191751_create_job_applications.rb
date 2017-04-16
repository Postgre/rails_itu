class CreateJobApplications < ActiveRecord::Migration
  def change
    create_table :job_applications do |t|
      t.integer :candidate_id
      t.integer :job_id
      t.text :cover_letter
      t.string :resume
      t.string :state
    end
  end
end
