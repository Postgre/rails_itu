class AddLastStateChangeAtToJobs < ActiveRecord::Migration
  def change
    say_with_time 'adding and populating a column with the last state change date' do
      add_column :jobs, :last_state_change_at, :datetime
      populate_last_state_change_at
    end
  end

  private

    def populate_last_state_change_at
      Job.all.each do |job|
        job.update_attribute(:last_state_change_at, job.versions.last.created_at) if job.versions.last
      end
    end
end
